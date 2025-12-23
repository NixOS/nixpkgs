{ lib }:

let
  inherit (lib)
    any
    filterAttrs
    foldl
    hasInfix
    isAttrs
    isFunction
    isList
    mapAttrs
    optional
    optionalAttrs
    optionalString
    removeSuffix
    replaceString
    toUpper
    ;

  inherit (lib.strings) toJSON;

  doubles = import ./doubles.nix { inherit lib; };
  parse = import ./parse.nix { inherit lib; };
  inspect = import ./inspect.nix { inherit lib; };
  platforms = import ./platforms.nix { inherit lib; };
  examples = import ./examples.nix { inherit lib; };
  architectures = import ./architectures.nix { inherit lib; };

  /**
    Elaborated systems contain functions, which means that they don't satisfy
    `==` for a lack of reflexivity.

    They might *appear* to satisfy `==` reflexivity when the same exact value is
    compared to itself, because object identity is used as an "optimization";
    compare the value with a reconstruction of itself, e.g. with `f == a: f a`,
    or perhaps calling `elaborate` twice, and one will see reflexivity fail as described.

    Hence a custom equality test.

    Note that this does not canonicalize the systems, so you'll want to make sure
    both arguments have been `elaborate`-d.
  */
  equals =
    let
      removeFunctions = a: filterAttrs (_: v: !isFunction v) a;
    in
    a: b: removeFunctions a == removeFunctions b;

  /**
    List of all Nix system doubles the nixpkgs flake will expose the package set
    for. All systems listed here must be supported by nixpkgs as `localSystem`.

    :::{.warning}
    This attribute is considered experimental and is subject to change.
    :::
  */
  flakeExposed = import ./flake-systems.nix { };

  # Turn localSystem or crossSystem, which could be system-string or attrset, into
  # attrset.
  systemToAttrs =
    systemOrArgs: if isAttrs systemOrArgs then systemOrArgs else { system = systemOrArgs; };

  # Elaborate a `localSystem` or `crossSystem` so that it contains everything
  # necessary.
  #
  # `parsed` is inferred from args, both because there are two options with one
  # clearly preferred, and to prevent cycles. A simpler fixed point where the RHS
  # always just used `final.*` would fail on both counts.
  elaborate =
    systemOrArgs:
    let
      allArgs = systemToAttrs systemOrArgs;

      # Those two will always be derived from "config", if given, so they should NOT
      # be overridden further down with "// args".
      args = removeAttrs allArgs [
        "parsed"
        "system"
      ];

      # TODO: deprecate args.rustc in favour of args.rust after 23.05 is EOL.
      rust = args.rust or args.rustc or { };

      final = {
        # Prefer to parse `config` as it is strictly more informative.
        parsed = parse.mkSystemFromString (args.config or allArgs.system);
        # This can be losslessly-extracted from `parsed` iff parsing succeeds.
        system = parse.doubleFromSystem final.parsed;
        # TODO: This currently can't be losslessly-extracted from `parsed`, for example
        # because of -mingw32.
        config = parse.tripleFromSystem final.parsed;
        # Determine whether we can execute binaries built for the provided platform.
        canExecute =
          platform:
          final.isAndroid == platform.isAndroid
          && parse.isCompatible final.parsed.cpu platform.parsed.cpu
          && final.parsed.kernel == platform.parsed.kernel
          && (
            # Only perform this check when cpus have the same type;
            # assume compatible cpu have all the instructions included
            final.parsed.cpu == platform.parsed.cpu
            ->
              # if both have gcc.arch defined, check whether final can execute the given platform
              (
                (final ? gcc.arch && platform ? gcc.arch)
                -> architectures.canExecute final.gcc.arch platform.gcc.arch
              )
              # if platform has gcc.arch defined but final doesn't, don't assume it can be executed
              || (platform ? gcc.arch -> !(final ? gcc.arch))
          )
          && (final.isDarwin -> (final.darwinPlatform == platform.darwinPlatform));

        isCompatible =
          _:
          throw "2022-05-23: isCompatible has been removed in favor of canExecute, refer to the 22.11 changelog for details";
        # Derived meta-data
        useLLVM = final.isFreeBSD || final.isOpenBSD;

        libc =
          if final.isDarwin then
            "libSystem"
          else if final.isMsvc then
            "ucrt"
          else if final.isMinGW then
            "msvcrt"
          else if final.isCygwin then
            "cygwin"
          else if final.isWasi then
            "wasilibc"
          else if final.isWasm && !final.isWasi then
            null
          else if final.isRedox then
            "relibc"
          else if final.isMusl then
            "musl"
          else if final.isUClibc then
            "uclibc"
          else if final.isAndroid then
            "bionic"
          else if
            final.isLinux # default
          then
            "glibc"
          else if final.isFreeBSD then
            "fblibc"
          else if final.isOpenBSD then
            "oblibc"
          else if final.isNetBSD then
            "nblibc"
          else if final.isAvr then
            "avrlibc"
          else if final.isGhcjs then
            null
          else if final.isNone then
            "newlib"
          # TODO(@Ericson2314) think more about other operating systems
          else
            "native/impure";
        # Choose what linker we wish to use by default. Someday we might also
        # choose the C compiler, runtime library, C++ standard library, etc. in
        # this way, nice and orthogonally, and deprecate `useLLVM`. But due to
        # the monolithic GCC build we cannot actually make those choices
        # independently, so we are just doing `linker` and keeping `useLLVM` for
        # now.
        linker =
          if final.useLLVM or false then
            "lld"
          else if final.isDarwin then
            "cctools"
          # "bfd" and "gold" both come from GNU binutils. The existence of Gold
          # is why we use the more obscure "bfd" and not "binutils" for this
          # choice.
          else
            "bfd";
        # The standard lib directory name that non-nixpkgs binaries distributed
        # for this platform normally assume.
        libDir =
          if final.isLinux then
            if final.isx86_64 || final.isMips64 || final.isPower64 then "lib64" else "lib"
          else
            null;
        extensions =
          optionalAttrs final.hasSharedLibraries {
            sharedLibrary =
              if final.isDarwin then
                ".dylib"
              else if (final.isWindows || final.isCygwin) then
                ".dll"
              else
                ".so";
          }
          // {
            staticLibrary = if final.isWindows then ".lib" else ".a";
            library = if final.isStatic then final.extensions.staticLibrary else final.extensions.sharedLibrary;
            executable = if (final.isWindows || final.isCygwin) then ".exe" else "";
          };
        # Misc boolean options
        useAndroidPrebuilt = false;
        useiOSPrebuilt = false;

        # Output from uname
        uname = {
          # uname -s
          system =
            {
              linux = "Linux";
              windows = "Windows";
              cygwin = "CYGWIN_NT";
              darwin = "Darwin";
              netbsd = "NetBSD";
              freebsd = "FreeBSD";
              openbsd = "OpenBSD";
              wasi = "Wasi";
              redox = "Redox";
              genode = "Genode";
            }
            .${final.parsed.kernel.name} or null;

          # uname -m
          processor =
            if final.isPower64 then
              "ppc64${optionalString final.isLittleEndian "le"}"
            else if final.isPower then
              "ppc${optionalString final.isLittleEndian "le"}"
            else if final.isMips64 then
              "mips64" # endianness is *not* included on mips64
            else if final.isDarwin then
              final.darwinArch
            else
              final.parsed.cpu.name;

          # uname -r
          release = null;
        };

        # It is important that hasSharedLibraries==false when the platform has no
        # dynamic library loader.  Various tools (including the gcc build system)
        # have knowledge of which platforms are incapable of dynamic linking, and
        # will still build on/for those platforms with --enable-shared, but simply
        # omit any `.so` build products such as libgcc_s.so.  When that happens,
        # it causes hard-to-troubleshoot build failures.
        hasSharedLibraries =
          with final;
          (
            isAndroid
            || isGnu
            || isMusl # Linux (allows multiple libcs)
            || isDarwin
            || isSunOS
            || isOpenBSD
            || isFreeBSD
            || isNetBSD # BSDs
            || isCygwin
            || isMinGW
            || isWindows # Windows
            || isWasm # WASM
          )
          && !isStatic;

        # The difference between `isStatic` and `hasSharedLibraries` is mainly the
        # addition of the `staticMarker` (see make-derivation.nix).  Some
        # platforms, like embedded machines without a libc (e.g. arm-none-eabi)
        # don't support dynamic linking, but don't get the `staticMarker`.
        # `pkgsStatic` sets `isStatic=true`, so `pkgsStatic.hostPlatform` always
        # has the `staticMarker`.
        isStatic = final.isWasi || final.isRedox;

        # Just a guess, based on `system`
        inherit
          (
            {
              linux-kernel = args.linux-kernel or { };
              gcc = args.gcc or { };
            }
            // platforms.select final
          )
          linux-kernel
          gcc
          ;

        # TODO: remove after 23.05 is EOL, with an error pointing to the rust.* attrs.
        rustc = args.rustc or { };

        linuxArch =
          if final.isAarch32 then
            "arm"
          else if final.isAarch64 then
            "arm64"
          else if final.isx86_32 then
            "i386"
          else if final.isx86_64 then
            "x86_64"
          # linux kernel does not distinguish microblaze/microblazeel
          else if final.isMicroBlaze then
            "microblaze"
          else if final.isMips32 then
            "mips"
          else if final.isMips64 then
            "mips" # linux kernel does not distinguish mips32/mips64
          else if final.isPower then
            "powerpc"
          else if final.isRiscV then
            "riscv"
          else if final.isS390 then
            "s390"
          else if final.isLoongArch64 then
            "loongarch"
          else
            final.parsed.cpu.name;

        # https://source.denx.de/u-boot/u-boot/-/blob/9bfb567e5f1bfe7de8eb41f8c6d00f49d2b9a426/common/image.c#L81-106
        ubootArch =
          if final.isx86_32 then
            "x86" # not i386
          else if final.isMips64 then
            "mips64" # uboot *does* distinguish between mips32/mips64
          else
            final.linuxArch; # other cases appear to agree with linuxArch

        qemuArch =
          if final.isAarch32 then
            "arm"
          else if final.isAarch64 then
            "aarch64"
          else if final.isS390 && !final.isS390x then
            null
          else if final.isx86_64 then
            "x86_64"
          else if final.isx86 then
            "i386"
          else if final.isMips64n32 then
            "mipsn32${optionalString final.isLittleEndian "el"}"
          else if final.isMips64 then
            "mips64${optionalString final.isLittleEndian "el"}"
          else
            final.uname.processor;

        # Name used by UEFI for architectures.
        efiArch =
          if final.isx86_32 then
            "ia32"
          else if final.isx86_64 then
            "x64"
          else if final.isAarch32 then
            "arm"
          else if final.isAarch64 then
            "aa64"
          else
            final.parsed.cpu.name;

        darwinArch = parse.darwinArch final.parsed.cpu;

        darwinPlatform =
          if final.isMacOS then
            "macos"
          else if final.isiOS then
            "ios"
          else
            null;
        # The canonical name for this attribute is darwinSdkVersion, but some
        # platforms define the old name "sdkVer".
        darwinSdkVersion = final.sdkVer or "14.4";
        darwinMinVersion = "14.0";
        darwinMinVersionVariable =
          if final.isMacOS then
            "MACOSX_DEPLOYMENT_TARGET"
          else if final.isiOS then
            "IPHONEOS_DEPLOYMENT_TARGET"
          else
            null;

        # Handle Android SDK and NDK versions.
        androidSdkVersion = args.androidSdkVersion or null;
        androidNdkVersion = args.androidNdkVersion or null;
      }
      // (
        let
          selectEmulator =
            pkgs:
            let
              wine = (pkgs.winePackagesFor "wine${toString final.parsed.cpu.bits}").minimal;
            in
            # Note: we guarantee that the return value is either `null` or a path
            # to an emulator program. That is, if an emulator requires additional
            # arguments, a wrapper should be used.
            if pkgs.stdenv.hostPlatform.canExecute final then
              lib.getExe (pkgs.writeShellScriptBin "exec" ''exec "$@"'')
            else if final.isWindows then
              "${wine}/bin/wine${optionalString (final.parsed.cpu.bits == 64) "64"}"
            else if final.isLinux && pkgs.stdenv.hostPlatform.isLinux && final.qemuArch != null then
              "${pkgs.qemu-user}/bin/qemu-${final.qemuArch}"
            else if final.isWasi then
              "${pkgs.wasmtime}/bin/wasmtime"
            else if final.isMmix then
              "${pkgs.mmixware}/bin/mmix"
            else
              null;
        in
        {
          emulatorAvailable = pkgs: (selectEmulator pkgs) != null;

          # whether final.emulator pkgs.pkgsStatic works
          staticEmulatorAvailable =
            pkgs: final.emulatorAvailable pkgs && (final.isLinux || final.isWasi || final.isMmix);

          emulator =
            pkgs:
            if (final.emulatorAvailable pkgs) then
              selectEmulator pkgs
            else
              throw "Don't know how to run ${final.config} executables.";

        }
      )
      // mapAttrs (n: v: v final.parsed) inspect.predicates
      // mapAttrs (n: v: v final.gcc.arch or "default") architectures.predicates
      // args
      // {
        rust = rust // {
          # Once args.rustc.platform.target-family is deprecated and
          # removed, there will no longer be any need to modify any
          # values from args.rust.platform, so we can drop all the
          # "args ? rust" etc. checks, and merge args.rust.platform in
          # /after/.
          platform = rust.platform or { } // {
            # https://doc.rust-lang.org/reference/conditional-compilation.html#target_arch
            arch =
              if rust ? platform then
                rust.platform.arch
              else if final.isAarch32 then
                "arm"
              else if final.isMips64 then
                "mips64" # never add "el" suffix
              else if final.isPower64 then
                "powerpc64" # never add "le" suffix
              else
                final.parsed.cpu.name;

            # https://doc.rust-lang.org/reference/conditional-compilation.html#target_os
            os =
              if rust ? platform then
                rust.platform.os or "none"
              else if final.isDarwin then
                "macos"
              else if final.isWasm && !final.isWasi then
                "unknown" # Needed for {wasm32,wasm64}-unknown-unknown.
              else
                final.parsed.kernel.name;

            # https://doc.rust-lang.org/reference/conditional-compilation.html#target_family
            target-family =
              if args ? rust.platform.target-family then
                args.rust.platform.target-family
              else if args ? rustc.platform.target-family then
                (
                  # Since https://github.com/rust-lang/rust/pull/84072
                  # `target-family` is a list instead of single value.
                  let
                    f = args.rustc.platform.target-family;
                  in
                  if isList f then f else [ f ]
                )
              else
                optional final.isUnix "unix" ++ optional final.isWindows "windows" ++ optional final.isWasm "wasm";

            # https://doc.rust-lang.org/reference/conditional-compilation.html#target_vendor
            vendor =
              let
                inherit (final.parsed) vendor;
              in
              rust.platform.vendor or {
                "w64" = "pc";
              }
              .${vendor.name} or vendor.name;
          };

          # The name of the rust target, even if it is custom. Adjustments are
          # because rust has slightly different naming conventions than we do.
          rustcTarget =
            let
              inherit (final.parsed) cpu kernel abi;
              cpu_ =
                rust.platform.arch or {
                  "armv7a" = "armv7";
                  "armv7l" = "armv7";
                  "armv6l" = "arm";
                  "armv5tel" = "armv5te";
                  "riscv32" = "riscv32gc";
                  "riscv64" = "riscv64gc";
                }
                .${cpu.name} or cpu.name;
              vendor_ = final.rust.platform.vendor;
              abi_ =
                # We're very explicit about the POWER ELF ABI w/ glibc in our parsing, while Rust is not.
                # TODO: Somehow ensure that Rust actually *uses* the correct ABI, and not just a libc-based default.
                if (lib.strings.hasPrefix "powerpc" cpu.name) && (lib.strings.hasPrefix "gnuabielfv" abi.name) then
                  "gnu"
                else
                  abi.name;
            in
            # TODO: deprecate args.rustc in favour of args.rust after 23.05 is EOL.
            args.rust.rustcTarget or args.rustc.config or (
              # Rust uses `wasm32-wasip?` rather than `wasm32-unknown-wasi`.
              # We cannot know which subversion does the user want, and
              # currently use WASI 0.1 as default for compatibility. Custom
              # users can set `rust.rustcTarget` to override it.
              if final.isWasi then
                "${cpu_}-wasip1"
              else
                "${cpu_}-${vendor_}-${kernel.name}${optionalString (abi.name != "unknown") "-${abi_}"}"
            );

          # The name of the rust target if it is standard, or the json file
          # containing the custom target spec.
          rustcTargetSpec =
            rust.rustcTargetSpec or (
              if rust ? platform then
                builtins.toFile (final.rust.rustcTarget + ".json") (toJSON rust.platform)
              else
                final.rust.rustcTarget
            );

          # The name of the rust target if it is standard, or the
          # basename of the file containing the custom target spec,
          # without the .json extension.
          #
          # This is the name used by Cargo for target subdirectories.
          cargoShortTarget = removeSuffix ".json" (baseNameOf "${final.rust.rustcTargetSpec}");

          # When used as part of an environment variable name, triples are
          # uppercased and have all hyphens replaced by underscores:
          #
          # https://github.com/rust-lang/cargo/pull/9169
          # https://github.com/rust-lang/cargo/issues/8285#issuecomment-634202431
          cargoEnvVarTarget = replaceString "-" "_" (toUpper final.rust.cargoShortTarget);

          # True if the target is no_std
          # https://github.com/rust-lang/rust/blob/2e44c17c12cec45b6a682b1e53a04ac5b5fcc9d2/src/bootstrap/config.rs#L415-L421
          isNoStdTarget = any (t: hasInfix t final.rust.rustcTarget) [
            "-none"
            "nvptx"
            "switch"
            "-uefi"
          ];
        };
      }
      // {
        go = {
          # See https://pkg.go.dev/internal/platform for a list of known platforms
          GOARCH =
            {
              "aarch64" = "arm64";
              "arm" = "arm";
              "armv5tel" = "arm";
              "armv6l" = "arm";
              "armv7l" = "arm";
              "i686" = "386";
              "loongarch64" = "loong64";
              "mips" = "mips";
              "mips64el" = "mips64le";
              "mipsel" = "mipsle";
              "powerpc64" = "ppc64";
              "powerpc64le" = "ppc64le";
              "riscv64" = "riscv64";
              "s390x" = "s390x";
              "x86_64" = "amd64";
              "wasm32" = "wasm";
            }
            .${final.parsed.cpu.name} or null;
          GOOS = if final.isWasi then "wasip1" else final.parsed.kernel.name;

          # See https://go.dev/wiki/GoArm
          GOARM = toString (lib.intersectLists [ (final.parsed.cpu.version or "") ] [ "5" "6" "7" ]);
        };

        node = {
          # See these locations for a list of known architectures/platforms:
          # - https://nodejs.org/api/os.html#osarch
          # - https://nodejs.org/api/os.html#osplatform
          arch =
            if final.isAarch then
              "arm" + lib.optionalString final.is64bit "64"
            else if final.isMips32 then
              "mips" + lib.optionalString final.isLittleEndian "el"
            else if final.isMips64 && final.isLittleEndian then
              "mips64el"
            else if final.isPower then
              "ppc" + lib.optionalString final.is64bit "64"
            else if final.isx86_64 then
              "x64"
            else if final.isx86_32 then
              "ia32"
            else if final.isS390x then
              "s390x"
            else if final.isRiscV64 then
              "riscv64"
            else if final.isLoongArch64 then
              "loong64"
            else
              null;

          platform =
            if final.isAndroid then
              "android"
            else if final.isDarwin then
              "darwin"
            else if final.isFreeBSD then
              "freebsd"
            else if final.isLinux then
              "linux"
            else if final.isOpenBSD then
              "openbsd"
            else if final.isSunOS then
              "sunos"
            else if (final.isWindows || final.isCygwin) then
              "win32"
            else
              null;
        };
      };
    in
    assert final.useAndroidPrebuilt -> final.isAndroid;
    assert foldl (pass: { assertion, message }: if assertion final then pass else throw message) true (
      final.parsed.abi.assertions or [ ]
    );
    final;

in

# Everything in this attrset is the public interface of the file.
{
  inherit
    architectures
    doubles
    elaborate
    equals
    examples
    flakeExposed
    inspect
    parse
    platforms
    systemToAttrs
    ;
}
