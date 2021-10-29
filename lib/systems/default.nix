{ lib }:
  let inherit (lib.attrsets) mapAttrs; in

rec {
  doubles = import ./doubles.nix { inherit lib; };
  parse = import ./parse.nix { inherit lib; };
  inspect = import ./inspect.nix { inherit lib; };
  platforms = import ./platforms.nix { inherit lib; };
  examples = import ./examples.nix { inherit lib; };
  architectures = import ./architectures.nix { inherit lib; };
  supported = import ./supported.nix { inherit lib; };

  # Elaborate a `localSystem` or `crossSystem` so that it contains everything
  # necessary.
  #
  # `parsed` is inferred from args, both because there are two options with one
  # clearly prefered, and to prevent cycles. A simpler fixed point where the RHS
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
      # Determine whether we are compatible with the provided CPU
      isCompatible = platform: parse.isCompatible final.parsed.cpu platform.parsed.cpu;
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
        else if final.isAvr                 then "avrlibc"
        else if final.isNone                then "newlib"
        else if final.isNetBSD              then "nblibc"
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
        # "bfd" and "gold" both come from GNU binutils. The existance of Gold
        # is why we use the more obscure "bfd" and not "binutils" for this
        # choice.
        else                                     "bfd";
      extensions = {
        sharedLibrary =
          /**/ if final.isDarwin  then ".dylib"
          else if final.isWindows then ".dll"
          else                         ".so";
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

         # uname -p
         processor = final.parsed.cpu.name;

         # uname -r
         release = null;
      };
      isStatic = final.isWasm || final.isRedox;

      # Just a guess, based on `system`
      inherit
        ({
          linux-kernel = args.linux-kernel or {};
          gcc = args.gcc or {};
          rustc = args.rust or {};
        } // platforms.select final)
        linux-kernel gcc rustc;

      linuxArch =
        if final.isAarch32 then "arm"
        else if final.isAarch64 then "arm64"
        else if final.isx86_32 then "i386"
        else if final.isx86_64 then "x86_64"
        else if final.isMips then "mips"
        else if final.isPower then "powerpc"
        else if final.isRiscV then "riscv"
        else if final.isS390 then "s390"
        else final.parsed.cpu.name;

      qemuArch =
        if final.isAarch32 then "arm"
        else if final.isx86_64 then "x86_64"
        else if final.isx86 then "i386"
        else {
          powerpc = "ppc";
          powerpcle = "ppc";
          powerpc64 = "ppc64";
          powerpc64le = "ppc64le";
        }.${final.parsed.cpu.name} or final.parsed.cpu.name;

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

      emulator = pkgs: let
        qemu-user = pkgs.qemu.override {
          smartcardSupport = false;
          spiceSupport = false;
          openGLSupport = false;
          virglSupport = false;
          vncSupport = false;
          gtkSupport = false;
          sdlSupport = false;
          pulseSupport = false;
          smbdSupport = false;
          seccompSupport = false;
          hostCpuTargets = ["${final.qemuArch}-linux-user"];
        };
        wine-name = "wine${toString final.parsed.cpu.bits}";
        wine = (pkgs.winePackagesFor wine-name).minimal;
      in
        if final.parsed.kernel.name == pkgs.stdenv.hostPlatform.parsed.kernel.name &&
           pkgs.stdenv.hostPlatform.isCompatible final
        then "${pkgs.runtimeShell} -c '\"$@\"' --"
        else if final.isWindows
        then "${wine}/bin/${wine-name}"
        else if final.isLinux && pkgs.stdenv.hostPlatform.isLinux
        then "${qemu-user}/bin/qemu-${final.qemuArch}"
        else if final.isWasi
        then "${pkgs.wasmtime}/bin/wasmtime"
        else if final.isMmix
        then "${pkgs.mmixware}/bin/mmix"
        else throw "Don't know how to run ${final.config} executables.";

    } // mapAttrs (n: v: v final.parsed) inspect.predicates
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
