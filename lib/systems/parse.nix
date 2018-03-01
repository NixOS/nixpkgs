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

  types.openSignifiantByte = mkOptionType {
    name = "significant-byte";
    description = "Endianness";
    merge = mergeOneOption;
  };

  types.significantByte = enum (attrValues significantBytes);

  significantBytes = setTypes types.openSignifiantByte {
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
    armv5tel = { bits = 32; significantByte = littleEndian; family = "arm"; };
    armv6l   = { bits = 32; significantByte = littleEndian; family = "arm"; };
    armv7a   = { bits = 32; significantByte = littleEndian; family = "arm"; };
    armv7l   = { bits = 32; significantByte = littleEndian; family = "arm"; };
    aarch64  = { bits = 64; significantByte = littleEndian; family = "aarch64"; };
    i686     = { bits = 32; significantByte = littleEndian; family = "x86"; };
    x86_64   = { bits = 64; significantByte = littleEndian; family = "x86"; };
    mips     = { bits = 32; significantByte = bigEndian;    family = "mips"; };
    mipsel   = { bits = 32; significantByte = littleEndian; family = "mips"; };
    mips64   = { bits = 64; significantByte = bigEndian;    family = "mips"; };
    mips64el = { bits = 64; significantByte = littleEndian; family = "mips"; };
    powerpc  = { bits = 32; significantByte = bigEndian;    family = "power"; };
    riscv32  = { bits = 32; significantByte = littleEndian; family = "riscv"; };
    riscv64  = { bits = 64; significantByte = littleEndian; family = "riscv"; };
    wasm32   = { bits = 32; significantByte = littleEndian; family = "wasm"; };
    wasm64   = { bits = 64; significantByte = littleEndian; family = "wasm"; };
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
    darwin  = { execFormat = macho;   families = { }; };
    freebsd = { execFormat = elf;     families = { inherit bsd; }; };
    hurd    = { execFormat = elf;     families = { }; };
    linux   = { execFormat = elf;     families = { }; };
    netbsd  = { execFormat = elf;     families = { inherit bsd; }; };
    none    = { execFormat = unknown; families = { }; };
    openbsd = { execFormat = elf;     families = { inherit bsd; }; };
    solaris = { execFormat = elf;     families = { }; };
    windows = { execFormat = pe;      families = { }; };
  } // { # aliases
    # TODO(@Ericson2314): Handle these Darwin version suffixes more generally.
    darwin10 = kernels.darwin;
    darwin14 = kernels.darwin;
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
    android = {};
    cygnus = {};
    gnu = {};
    msvc = {};
    eabi = {};
    androideabi = {};
    gnueabi = {};
    gnueabihf = {};
    musleabi = {};
    musleabihf = {};
    musl = {};

    unknown = {};
  };

  ################################################################################

  types.system = mkOptionType {
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
    assert types.system.check components;
    setType "system" components;

  mkSkeletonFromList = l: {
    "2" = # We only do 2-part hacks for things Nix already supports
      if elemAt l 1 == "cygwin"
        then { cpu = elemAt l 0;                      kernel = "windows";  abi = "cygnus";   }
      else if elemAt l 1 == "gnu"
        then { cpu = elemAt l 0;                      kernel = "hurd";     abi = "gnu";      }
      else   { cpu = elemAt l 0;                      kernel = elemAt l 1;                   };
    "3" = # Awkwards hacks, beware!
      if elemAt l 1 == "apple"
        then { cpu = elemAt l 0; vendor = "apple";    kernel = elemAt l 2;                   }
      else if (elemAt l 1 == "linux") || (elemAt l 2 == "gnu")
        then { cpu = elemAt l 0;                      kernel = elemAt l 1; abi = elemAt l 2; }
      else if (elemAt l 2 == "mingw32") # autotools breaks on -gnu for window
        then { cpu = elemAt l 0; vendor = elemAt l 1; kernel = "windows";  abi = "gnu"; }
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
      kernel = getKernel args.kernel;
      abi =
        /**/ if args ? abi       then getAbi args.abi
        else if isLinux   parsed then abis.gnu
        else if isWindows parsed then abis.gnu
        else                     abis.unknown;
    };

  in mkSystem parsed;

  mkSystemFromString = s: mkSystemFromSkeleton (mkSkeletonFromList (lib.splitString "-" s));

  doubleFromSystem = { cpu, vendor, kernel, abi, ... }:
    if abi == abis.cygnus
    then "${cpu.name}-cygwin"
    else "${cpu.name}-${kernel.name}";

  tripleFromSystem = { cpu, vendor, kernel, abi, ... } @ sys: assert isSystem sys; let
    optAbi = lib.optionalString (abi != abis.unknown) "-${abi.name}";
  in "${cpu.name}-${vendor.name}-${kernel.name}${optAbi}";

  ################################################################################

}
