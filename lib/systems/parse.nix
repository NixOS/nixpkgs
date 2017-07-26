# Define the list of system with their properties.
#
# See https://clang.llvm.org/docs/CrossCompilation.html and
# http://llvm.org/docs/doxygen/html/Triple_8cpp_source.html especially
# Triple::normalize. Parsing should essentially act as a more conservative
# version of that last function.

with import ../lists.nix;
with import ../types.nix;
with import ../attrsets.nix;
with (import ./inspect.nix).predicates;

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
    powerpc  = { bits = 32; significantByte = bigEndian;    family = "power"; };
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
  };

  isKernel = x: isType "kernel" x;
  kernels = with execFormats; with kernelFamilies; setTypesAssert "kernel"
    (x: isExecFormat x.execFormat && all isKernelFamily (attrValues x.families))
  {
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

}
