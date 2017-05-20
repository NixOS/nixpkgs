# Define the list of system with their properties.
#
# See https://clang.llvm.org/docs/CrossCompilation.html and
# http://llvm.org/docs/doxygen/html/Triple_8cpp_source.html especially
# Triple::normalize. Parsing should essentially act as a more conservative
# version of that last function.

with import ../lists.nix;
with import ../types.nix;
with import ../attrsets.nix;

let
  lib = import ../default.nix;
  setTypesAssert = type: pred:
    mapAttrs (name: value:
      assert pred value;
      setType type ({ inherit name; } // value));
  setTypes = type: setTypesAssert type (_: true);

in

rec {

  isSignificantByte = isType "significant-byte";
  significantBytes = setTypes "significant-byte" {
    bigEndian = {};
    littleEndian = {};
  };

  isCpuType = isType "cpu-type";
  cpuTypes = with significantBytes; setTypesAssert "cpu-type"
    (x: elem x.bits [8 16 32 64 128]
        && (if 8 < x.bits
            then isSignificantByte x.significantByte
            else !(x ? significantByte)))
  {
    arm      = { bits = 32; significantByte = littleEndian; family = "arm"; };
    armv5tel = { bits = 32; significantByte = littleEndian; family = "arm"; };
    armv6l   = { bits = 32; significantByte = littleEndian; family = "arm"; };
    armv7a   = { bits = 32; significantByte = littleEndian; family = "arm"; };
    armv7l   = { bits = 32; significantByte = littleEndian; family = "arm"; };
    aarch64  = { bits = 64; significantByte = littleEndian; family = "arm"; };
    i686     = { bits = 32; significantByte = littleEndian; family = "x86"; };
    x86_64   = { bits = 64; significantByte = littleEndian; family = "x86"; };
    mips64el = { bits = 32; significantByte = littleEndian; family = "mips"; };
    powerpc  = { bits = 32; significantByte = bigEndian;    family = "powerpc"; };
  };

  isVendor = isType "vendor";
  vendors = setTypes "vendor" {
    apple = {};
    pc = {};

    unknown = {};
  };

  isExecFormat = isType "exec-format";
  execFormats = setTypes "exec-format" {
    aout = {}; # a.out
    elf = {};
    macho = {};
    pe = {};

    unknown = {};
  };

  isKernelFamily = isType "kernel-family";
  kernelFamilies = setTypes "kernel-family" {
    bsd = {};
    unix = {};
  };

  isKernel = x: isType "kernel" x;
  kernels = with execFormats; with kernelFamilies; setTypesAssert "kernel"
    (x: isExecFormat x.execFormat && all isKernelFamily (attrValues x.families))
  {
    darwin  = { execFormat = macho;   families = { inherit unix; }; };
    freebsd = { execFormat = elf;     families = { inherit unix bsd; }; };
    linux   = { execFormat = elf;     families = { inherit unix; }; };
    netbsd  = { execFormat = elf;     families = { inherit unix bsd; }; };
    none    = { execFormat = unknown; families = { inherit unix; }; };
    openbsd = { execFormat = elf;     families = { inherit unix bsd; }; };
    solaris = { execFormat = elf;     families = { inherit unix; }; };
    windows = { execFormat = pe;      families = { }; };
  } // { # aliases
    # TODO(@Ericson2314): Handle these Darwin version suffixes more generally.
    darwin10 = kernels.darwin;
    darwin14 = kernels.darwin;
    win32 = kernels.windows;
  };

  isAbi = isType "abi";
  abis = setTypes "abi" {
    cygnus = {};
    gnu = {};
    msvc = {};
    eabi = {};
    androideabi = {};
    gnueabi = {};
    gnueabihf = {};

    unknown = {};
  };

  isSystem = isType "system";
  mkSystem = { cpu, vendor, kernel, abi }:
    assert isCpuType cpu && isVendor vendor && isKernel kernel && isAbi abi;
    setType "system" {
      inherit cpu vendor kernel abi;
    };

  is64Bit = matchAttrs { cpu = { bits = 64; }; };
  is32Bit = matchAttrs { cpu = { bits = 32; }; };
  isi686 = matchAttrs { cpu = cpuTypes.i686; };
  isx86_64 = matchAttrs { cpu = cpuTypes.x86_64; };

  isDarwin = matchAttrs { kernel = kernels.darwin; };
  isLinux = matchAttrs { kernel = kernels.linux; };
  isUnix = matchAttrs { kernel = { families = { inherit (kernelFamilies) unix; }; }; };
  isWindows = matchAttrs { kernel = kernels.windows; };
  isCygwin = matchAttrs { kernel = kernels.windows; abi = abis.cygnus; };
  isMinGW = matchAttrs { kernel = kernels.windows; abi = abis.gnu; };


  mkSkeletonFromList = l: {
    "2" = # We only do 2-part hacks for things Nix already supports
      if elemAt l 1 == "cygwin"
        then { cpu = elemAt l 0;                      kernel = "windows"; abi = "cygnus";    }
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

    system = rec {
      cpu = getCpu args.cpu;
      vendor =
        /**/ if args ? vendor    then getVendor args.vendor
        else if isDarwin  system then vendors.apple
        else if isWindows system then vendors.pc
        else                     vendors.unknown;
      kernel = getKernel args.kernel;
      abi =
        /**/ if args ? abi       then getAbi args.abi
        else if isLinux   system then abis.gnu
        else if isWindows system then abis.gnu
        else                     abis.unknown;
    };

  in mkSystem system;

  mkSystemFromString = s: mkSystemFromSkeleton (mkSkeletonFromList (lib.splitString "-" s));

  doubleFromSystem = { cpu, vendor, kernel, abi, ... }:
    if vendor == kernels.windows && abi == abis.cygnus
    then "${cpu.name}-cygwin"
    else "${cpu.name}-${kernel.name}";

  tripleFromSystem = { cpu, vendor, kernel, abi, ... } @ sys: assert isSystem sys; let
    optAbi = lib.optionalString (abi != abis.unknown) "-${abi.name}";
  in "${cpu.name}-${vendor.name}-${kernel.name}${optAbi}";

}
