# Define the list of system with their properties.
#
# See https://clang.llvm.org/docs/CrossCompilation.html and
# http://llvm.org/docs/doxygen/html/Triple_8cpp_source.html especially
# Triple::normalize. Parsing should essentially act as a more conservative
# version of that last function.
#
# Most of the types below come in "open" and "closed" pairs. The open ones
# specify what information we need to know about systems in general, and the
# closed ones are sub-types representing the whitelist of systems we support in
# practice.
#
# Code in the remainder of nixpkgs shouldn't rely on the closed ones in
# e.g. exhaustive cases. Its more a sanity check to make sure nobody defines
# systems that overlap with existing ones and won't notice something amiss.
#
{ lib }:
with lib.lists;
with lib.types;
with lib.attrsets;
with lib.strings;
with (import ./inspect.nix { inherit lib; }).predicates;

let
  inherit (lib.options) mergeOneOption;

  setTypes = type:
    mapAttrs (name: value:
      assert type.check value;
      setType type.name ({ inherit name; } // value));

in

rec {

  ################################################################################

  types.openSignificantByte = mkOptionType {
    name = "significant-byte";
    description = "Endianness";
    merge = mergeOneOption;
  };

  types.significantByte = enum (attrValues significantBytes);

  significantBytes = setTypes types.openSignificantByte {
    bigEndian = {};
    littleEndian = {};
  };

  ################################################################################

  # Reasonable power of 2
  types.bitWidth = enum [ 8 16 32 64 128 ];

  ################################################################################

  types.openCpuType = mkOptionType {
    name = "cpu-type";
    description = "instruction set architecture name and information";
    merge = mergeOneOption;
    check = x: types.bitWidth.check x.bits
      && (if 8 < x.bits
          then types.significantByte.check x.significantByte
          else !(x ? significantByte));
  };

  types.cpuType = enum (attrValues cpuTypes);

  cpuTypes = with significantBytes; setTypes types.openCpuType {
    arm      = { bits = 32; significantByte = littleEndian; family = "arm"; };
    armv5tel = { bits = 32; significantByte = littleEndian; family = "arm"; version = "5"; };
    armv6m   = { bits = 32; significantByte = littleEndian; family = "arm"; version = "6"; };
    armv6l   = { bits = 32; significantByte = littleEndian; family = "arm"; version = "6"; };
    armv7a   = { bits = 32; significantByte = littleEndian; family = "arm"; version = "7"; };
    armv7r   = { bits = 32; significantByte = littleEndian; family = "arm"; version = "7"; };
    armv7m   = { bits = 32; significantByte = littleEndian; family = "arm"; version = "7"; };
    armv7l   = { bits = 32; significantByte = littleEndian; family = "arm"; version = "7"; };
    armv8a   = { bits = 32; significantByte = littleEndian; family = "arm"; version = "8"; };
    armv8r   = { bits = 32; significantByte = littleEndian; family = "arm"; version = "8"; };
    armv8m   = { bits = 32; significantByte = littleEndian; family = "arm"; version = "8"; };
    aarch64  = { bits = 64; significantByte = littleEndian; family = "arm"; version = "8"; };
    aarch64_be = { bits = 64; significantByte = bigEndian; family = "arm"; version = "8"; };

    i386     = { bits = 32; significantByte = littleEndian; family = "x86"; };
    i486     = { bits = 32; significantByte = littleEndian; family = "x86"; };
    i586     = { bits = 32; significantByte = littleEndian; family = "x86"; };
    i686     = { bits = 32; significantByte = littleEndian; family = "x86"; };
    x86_64   = { bits = 64; significantByte = littleEndian; family = "x86"; };

    mips     = { bits = 32; significantByte = bigEndian;    family = "mips"; };
    mipsel   = { bits = 32; significantByte = littleEndian; family = "mips"; };
    mips64   = { bits = 64; significantByte = bigEndian;    family = "mips"; };
    mips64el = { bits = 64; significantByte = littleEndian; family = "mips"; };

    powerpc  = { bits = 32; significantByte = bigEndian;    family = "power"; };
    powerpc64 = { bits = 64; significantByte = bigEndian; family = "power"; };
    powerpc64le = { bits = 64; significantByte = littleEndian; family = "power"; };
    powerpcle = { bits = 32; significantByte = littleEndian; family = "power"; };

    riscv32  = { bits = 32; significantByte = littleEndian; family = "riscv"; };
    riscv64  = { bits = 64; significantByte = littleEndian; family = "riscv"; };

    sparc    = { bits = 32; significantByte = bigEndian;    family = "sparc"; };
    sparc64  = { bits = 64; significantByte = bigEndian;    family = "sparc"; };

    wasm32   = { bits = 32; significantByte = littleEndian; family = "wasm"; };
    wasm64   = { bits = 64; significantByte = littleEndian; family = "wasm"; };
    
    alpha    = { bits = 64; significantByte = littleEndian; family = "alpha"; };

    avr      = { bits = 8; family = "avr"; };
  };

  ################################################################################

  types.openVendor = mkOptionType {
    name = "vendor";
    description = "vendor for the platform";
    merge = mergeOneOption;
  };

  types.vendor = enum (attrValues vendors);

  vendors = setTypes types.openVendor {
    apple = {};
    pc = {};

    none = {};
    unknown = {};
  };

  ################################################################################

  types.openExecFormat = mkOptionType {
    name = "exec-format";
    description = "executable container used by the kernel";
    merge = mergeOneOption;
  };

  types.execFormat = enum (attrValues execFormats);

  execFormats = setTypes types.openExecFormat {
    aout = {}; # a.out
    elf = {};
    macho = {};
    pe = {};

    unknown = {};
  };

  ################################################################################

  types.openKernelFamily = mkOptionType {
    name = "exec-format";
    description = "executable container used by the kernel";
    merge = mergeOneOption;
  };

  types.kernelFamily = enum (attrValues kernelFamilies);

  kernelFamilies = setTypes types.openKernelFamily {
    bsd = {};
    darwin = {};
  };

  ################################################################################

  types.openKernel = mkOptionType {
    name = "kernel";
    description = "kernel name and information";
    merge = mergeOneOption;
    check = x: types.execFormat.check x.execFormat
        && all types.kernelFamily.check (attrValues x.families);
  };

  types.kernel = enum (attrValues kernels);

  kernels = with execFormats; with kernelFamilies; setTypes types.openKernel {
    # TODO(@Ericson2314): Don't want to mass-rebuild yet to keeping 'darwin' as
    # the nnormalized name for macOS.
    macos   = { execFormat = macho;   families = { inherit darwin; }; name = "darwin"; };
    ios     = { execFormat = macho;   families = { inherit darwin; }; };
    freebsd = { execFormat = elf;     families = { inherit bsd; }; };
    linux   = { execFormat = elf;     families = { }; };
    netbsd  = { execFormat = elf;     families = { inherit bsd; }; };
    none    = { execFormat = unknown; families = { }; };
    openbsd = { execFormat = elf;     families = { inherit bsd; }; };
    solaris = { execFormat = elf;     families = { }; };
    windows = { execFormat = pe;      families = { }; };
  } // { # aliases
    # 'darwin' is the kernel for all of them. We choose macOS by default.
    darwin = kernels.macos;
    watchos = kernels.ios;
    tvos = kernels.ios;
    win32 = kernels.windows;
  };

  ################################################################################

  types.openAbi = mkOptionType {
    name = "abi";
    description = "binary interface for compiled code and syscalls";
    merge = mergeOneOption;
  };

  types.abi = enum (attrValues abis);

  abis = setTypes types.openAbi {
    cygnus       = {};
    msvc         = {};

    # Note: eabi is specific to ARM and PowerPC.
    # On PowerPC, this corresponds to PPCEABI.
    # On ARM, this corresponds to ARMEABI.
    eabi         = { float = "soft"; };
    eabihf       = { float = "hard"; };

    # Other architectures should use ELF in embedded situations.
    elf          = {};

    androideabi  = {};
    android      = {
      assertions = [
        { assertion = platform: !platform.isAarch32;
          message = ''
            The "android" ABI is not for 32-bit ARM. Use "androideabi" instead.
          '';
        }
      ];
    };

    gnueabi      = { float = "soft"; };
    gnueabihf    = { float = "hard"; };
    gnu          = {
      assertions = [
        { assertion = platform: !platform.isAarch32;
          message = ''
            The "gnu" ABI is ambiguous on 32-bit ARM. Use "gnueabi" or "gnueabihf" instead.
          '';
        }
      ];
    };

    musleabi     = { float = "soft"; };
    musleabihf   = { float = "hard"; };
    musl         = {};

    uclibceabihf = { float = "soft"; };
    uclibceabi   = { float = "hard"; };
    uclibc       = {};

    unknown = {};
  };

  ################################################################################

  types.parsedPlatform = mkOptionType {
    name = "system";
    description = "fully parsed representation of llvm- or nix-style platform tuple";
    merge = mergeOneOption;
    check = { cpu, vendor, kernel, abi }:
           types.cpuType.check cpu
        && types.vendor.check vendor
        && types.kernel.check kernel
        && types.abi.check abi;
  };

  isSystem = isType "system";

  mkSystem = components:
    assert types.parsedPlatform.check components;
    setType "system" components;

  mkSkeletonFromList = l: {
    "1" = if elemAt l 0 == "avr"
      then { cpu = elemAt l 0; kernel = "none"; abi = "unknown"; }
      else throw "Target specification with 1 components is ambiguous";
    "2" = # We only do 2-part hacks for things Nix already supports
      if elemAt l 1 == "cygwin"
        then { cpu = elemAt l 0;                      kernel = "windows";  abi = "cygnus";   }
      # MSVC ought to be the default ABI so this case isn't needed. But then it
      # becomes difficult to handle the gnu* variants for Aarch32 correctly for
      # minGW. So it's easier to make gnu* the default for the MinGW, but
      # hack-in MSVC for the non-MinGW case right here.
      else if elemAt l 1 == "windows"
        then { cpu = elemAt l 0;                      kernel = "windows";  abi = "msvc";     }
      else if (elemAt l 1) == "elf"
        then { cpu = elemAt l 0; vendor = "unknown";  kernel = "none";     abi = elemAt l 1; }
      else   { cpu = elemAt l 0;                      kernel = elemAt l 1;                   };
    "3" = # Awkwards hacks, beware!
      if elemAt l 1 == "apple"
        then { cpu = elemAt l 0; vendor = "apple";    kernel = elemAt l 2;                   }
      else if (elemAt l 1 == "linux") || (elemAt l 2 == "gnu")
        then { cpu = elemAt l 0;                      kernel = elemAt l 1; abi = elemAt l 2; }
      else if (elemAt l 2 == "mingw32") # autotools breaks on -gnu for window
        then { cpu = elemAt l 0; vendor = elemAt l 1; kernel = "windows";                    }
      else if hasPrefix "netbsd" (elemAt l 2)
        then { cpu = elemAt l 0; vendor = elemAt l 1;    kernel = elemAt l 2;                }
      else if (elem (elemAt l 2) ["eabi" "eabihf" "elf"])
        then { cpu = elemAt l 0; vendor = "unknown"; kernel = elemAt l 1; abi = elemAt l 2; }
      else throw "Target specification with 3 components is ambiguous";
    "4" =    { cpu = elemAt l 0; vendor = elemAt l 1; kernel = elemAt l 2; abi = elemAt l 3; };
  }.${toString (length l)}
    or (throw "system string has invalid number of hyphen-separated components");

  # This should revert the job done by config.guess from the gcc compiler.
  mkSystemFromSkeleton = { cpu
                         , # Optional, but fallback too complex for here.
                           # Inferred below instead.
                           vendor ? assert false; null
                         , kernel
                         , # Also inferred below
                           abi    ? assert false; null
                         } @ args: let
    getCpu    = name: cpuTypes.${name} or (throw "Unknown CPU type: ${name}");
    getVendor = name:  vendors.${name} or (throw "Unknown vendor: ${name}");
    getKernel = name:  kernels.${name} or (throw "Unknown kernel: ${name}");
    getAbi    = name:     abis.${name} or (throw "Unknown ABI: ${name}");

    parsed = rec {
      cpu = getCpu args.cpu;
      vendor =
        /**/ if args ? vendor    then getVendor args.vendor
        else if isDarwin  parsed then vendors.apple
        else if isWindows parsed then vendors.pc
        else                     vendors.unknown;
      kernel = if hasPrefix "darwin" args.kernel      then getKernel "darwin"
               else if hasPrefix "netbsd" args.kernel then getKernel "netbsd"
               else                                   getKernel args.kernel;
      abi =
        /**/ if args ? abi       then getAbi args.abi
        else if isLinux parsed || isWindows parsed then
          if isAarch32 parsed then
            if lib.versionAtLeast (parsed.cpu.version or "0") "6"
            then abis.gnueabihf
            else abis.gnueabi
          else abis.gnu
        else                     abis.unknown;
    };

  in mkSystem parsed;

  mkSystemFromString = s: mkSystemFromSkeleton (mkSkeletonFromList (lib.splitString "-" s));

  doubleFromSystem = { cpu, vendor, kernel, abi, ... }:
    /**/ if abi == abis.cygnus       then "${cpu.name}-cygwin"
    else if kernel.families ? darwin then "${cpu.name}-darwin"
    else "${cpu.name}-${kernel.name}";

  tripleFromSystem = { cpu, vendor, kernel, abi, ... } @ sys: assert isSystem sys; let
    optAbi = lib.optionalString (abi != abis.unknown) "-${abi.name}";
  in "${cpu.name}-${vendor.name}-${kernel.name}${optAbi}";

  ################################################################################

}
