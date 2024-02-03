{ lib }:
  let inherit (lib.attrsets) mapAttrs; in

rec {
  doubles = import ./doubles.nix { inherit lib; };
  parse = import ./parse.nix { inherit lib; };
  inspect = import ./inspect.nix { inherit lib; };
  platforms = import ./platforms.nix { inherit lib; };
  examples = import ./examples.nix { inherit lib; };
  architectures = import ./architectures.nix { inherit lib; };

  /*
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
    let removeFunctions = a: lib.filterAttrs (_: v: !builtins.isFunction v) a;
    in a: b: removeFunctions a == removeFunctions b;

  /* List of all Nix system doubles the nixpkgs flake will expose the package set
     for. All systems listed here must be supported by nixpkgs as `localSystem`.

     **Warning**: This attribute is considered experimental and is subject to change.
  */
  flakeExposed = import ./flake-systems.nix { };

  # Elaborate a `localSystem` or `crossSystem` so that it contains everything
  # necessary.
  #
  # `parsed` is inferred from args, both because there are two options with one
  # clearly preferred, and to prevent cycles. A simpler fixed point where the RHS
  # always just used `final.*` would fail on both counts.
  elaborate = args': let
    args = if lib.isString args' then { system = args'; }
           else args';
    final = {
      # Prefer to parse `config` as it is strictly more informative.
      parsed = parse.mkSystemFromString (if args ? config then args.config else args.system);
      # Either of these can be losslessly-extracted from `parsed` iff parsing succeeds.
      system = parse.doubleFromSystem final.parsed;
      config = parse.tripleFromSystem final.parsed;
      # Determine whether we can execute binaries built for the provided platform.
      canExecute = platform:
        final.isAndroid == platform.isAndroid &&
        parse.isCompatible final.parsed.cpu platform.parsed.cpu
        && final.parsed.kernel == platform.parsed.kernel;
      isCompatible = _: throw "2022-05-23: isCompatible has been removed in favor of canExecute, refer to the 22.11 changelog for details";
      # Derived meta-data
      libc =
        /**/ if final.isDarwin              then "libSystem"
        else if final.isMinGW               then "msvcrt"
        else if final.isWasi                then "wasilibc"
        else if final.isRedox               then "relibc"
        else if final.isMusl                then "musl"
        else if final.isUClibc              then "uclibc"
        else if final.isAndroid             then "bionic"
        else if final.isLinux /* default */ then "glibc"
        else if final.isFreeBSD             then "fblibc"
        else if final.isNetBSD              then "nblibc"
        else if final.isAvr                 then "avrlibc"
        else if final.isGhcjs               then null
        else if final.isNone                then "newlib"
        # TODO(@Ericson2314) think more about other operating systems
        else                                     "native/impure";
      # Choose what linker we wish to use by default. Someday we might also
      # choose the C compiler, runtime library, C++ standard library, etc. in
      # this way, nice and orthogonally, and deprecate `useLLVM`. But due to
      # the monolithic GCC build we cannot actually make those choices
      # independently, so we are just doing `linker` and keeping `useLLVM` for
      # now.
      linker =
        /**/ if final.useLLVM or false      then "lld"
        else if final.isDarwin              then "cctools"
        # "bfd" and "gold" both come from GNU binutils. The existence of Gold
        # is why we use the more obscure "bfd" and not "binutils" for this
        # choice.
        else                                     "bfd";
      extensions = lib.optionalAttrs final.hasSharedLibraries {
        sharedLibrary =
          if      final.isDarwin  then ".dylib"
          else if final.isWindows then ".dll"
          else                         ".so";
      } // {
        staticLibrary =
          /**/ if final.isWindows then ".lib"
          else                         ".a";
        library =
          /**/ if final.isStatic then final.extensions.staticLibrary
          else                        final.extensions.sharedLibrary;
        executable =
          /**/ if final.isWindows then ".exe"
          else                         "";
      };
      # Misc boolean options
      useAndroidPrebuilt = false;
      useiOSPrebuilt = false;

      # Output from uname
      uname = {
        # uname -s
        system = {
          linux = "Linux";
          windows = "Windows";
          darwin = "Darwin";
          netbsd = "NetBSD";
          freebsd = "FreeBSD";
          openbsd = "OpenBSD";
          wasi = "Wasi";
          redox = "Redox";
          genode = "Genode";
        }.${final.parsed.kernel.name} or null;

         # uname -m
         processor =
           if final.isPower64
           then "ppc64${lib.optionalString final.isLittleEndian "le"}"
           else if final.isPower
           then "ppc${lib.optionalString final.isLittleEndian "le"}"
           else if final.isMips64
           then "mips64"  # endianness is *not* included on mips64
           else final.parsed.cpu.name;

         # uname -r
         release = null;
      };

      # It is important that hasSharedLibraries==false when the platform has no
      # dynamic library loader.  Various tools (including the gcc build system)
      # have knowledge of which platforms are incapable of dynamic linking, and
      # will still build on/for those platforms with --enable-shared, but simply
      # omit any `.so` build products such as libgcc_s.so.  When that happens,
      # it causes hard-to-troubleshoot build failures.
      hasSharedLibraries = with final;
        (isAndroid || isGnu || isMusl                                  # Linux (allows multiple libcs)
         || isDarwin || isSunOS || isOpenBSD || isFreeBSD || isNetBSD  # BSDs
         || isCygwin || isMinGW                                        # Windows
        ) && !isStatic;

      # The difference between `isStatic` and `hasSharedLibraries` is mainly the
      # addition of the `staticMarker` (see make-derivation.nix).  Some
      # platforms, like embedded machines without a libc (e.g. arm-none-eabi)
      # don't support dynamic linking, but don't get the `staticMarker`.
      # `pkgsStatic` sets `isStatic=true`, so `pkgsStatic.hostPlatform` always
      # has the `staticMarker`.
      isStatic = final.isWasm || final.isRedox;

      # Just a guess, based on `system`
      inherit
        ({
          linux-kernel = args.linux-kernel or {};
          gcc = args.gcc or {};
          rustc = args.rustc or {};
        } // platforms.select final)
        linux-kernel gcc rustc;

      linuxArch =
        if final.isAarch32 then "arm"
        else if final.isAarch64 then "arm64"
        else if final.isx86_32 then "i386"
        else if final.isx86_64 then "x86_64"
        # linux kernel does not distinguish microblaze/microblazeel
        else if final.isMicroBlaze then "microblaze"
        else if final.isMips32 then "mips"
        else if final.isMips64 then "mips"    # linux kernel does not distinguish mips32/mips64
        else if final.isPower then "powerpc"
        else if final.isRiscV then "riscv"
        else if final.isS390 then "s390"
        else if final.isLoongArch64 then "loongarch"
        else final.parsed.cpu.name;

      # https://source.denx.de/u-boot/u-boot/-/blob/9bfb567e5f1bfe7de8eb41f8c6d00f49d2b9a426/common/image.c#L81-106
      ubootArch =
        if      final.isx86_32 then "x86"    # not i386
        else if final.isMips64 then "mips64" # uboot *does* distinguish between mips32/mips64
        else final.linuxArch;                # other cases appear to agree with linuxArch

      qemuArch =
        if final.isAarch32 then "arm"
        else if final.isS390 && !final.isS390x then null
        else if final.isx86_64 then "x86_64"
        else if final.isx86 then "i386"
        else if final.isMips64n32 then "mipsn32${lib.optionalString final.isLittleEndian "el"}"
        else if final.isMips64 then "mips64${lib.optionalString final.isLittleEndian "el"}"
        else final.uname.processor;

      # Name used by UEFI for architectures.
      efiArch =
        if final.isx86_32 then "ia32"
        else if final.isx86_64 then "x64"
        else if final.isAarch32 then "arm"
        else if final.isAarch64 then "aa64"
        else final.parsed.cpu.name;

      darwinArch = {
        armv7a  = "armv7";
        aarch64 = "arm64";
      }.${final.parsed.cpu.name} or final.parsed.cpu.name;

      darwinPlatform =
        if final.isMacOS then "macos"
        else if final.isiOS then "ios"
        else null;
      # The canonical name for this attribute is darwinSdkVersion, but some
      # platforms define the old name "sdkVer".
      darwinSdkVersion = final.sdkVer or (if final.isAarch64 then "11.0" else "10.12");
      darwinMinVersion = final.darwinSdkVersion;
      darwinMinVersionVariable =
        if final.isMacOS then "MACOSX_DEPLOYMENT_TARGET"
        else if final.isiOS then "IPHONEOS_DEPLOYMENT_TARGET"
        else null;
    } // (
      let
        selectEmulator = pkgs:
          let
            qemu-user = pkgs.qemu.override {
              smartcardSupport = false;
              spiceSupport = false;
              openGLSupport = false;
              virglSupport = false;
              vncSupport = false;
              gtkSupport = false;
              sdlSupport = false;
              pulseSupport = false;
              pipewireSupport = false;
              smbdSupport = false;
              seccompSupport = false;
              enableDocs = false;
              hostCpuTargets = [ "${final.qemuArch}-linux-user" ];
            };
            wine = (pkgs.winePackagesFor "wine${toString final.parsed.cpu.bits}").minimal;
          in
          if pkgs.stdenv.hostPlatform.canExecute final
          then "${pkgs.runtimeShell} -c '\"$@\"' --"
          else if final.isWindows
          then "${wine}/bin/wine${lib.optionalString (final.parsed.cpu.bits == 64) "64"}"
          else if final.isLinux && pkgs.stdenv.hostPlatform.isLinux && final.qemuArch != null
          then "${qemu-user}/bin/qemu-${final.qemuArch}"
          else if final.isWasi
          then "${pkgs.wasmtime}/bin/wasmtime"
          else if final.isMmix
          then "${pkgs.mmixware}/bin/mmix"
          else null;
      in {
        emulatorAvailable = pkgs: (selectEmulator pkgs) != null;

        emulator = pkgs:
          if (final.emulatorAvailable pkgs)
          then selectEmulator pkgs
          else throw "Don't know how to run ${final.config} executables.";

    }) // mapAttrs (n: v: v final.parsed) inspect.predicates
      // mapAttrs (n: v: v final.gcc.arch or "default") architectures.predicates
      // args;
  in assert final.useAndroidPrebuilt -> final.isAndroid;
     assert lib.foldl
       (pass: { assertion, message }:
         if assertion final
         then pass
         else throw message)
       true
       (final.parsed.abi.assertions or []);
    final;
}
