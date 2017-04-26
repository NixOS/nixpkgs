# Define the list of system with their properties.  Only systems tested for
# Nixpkgs are listed below

with import ../lists.nix;
with import ../types.nix;
with import ../attrsets.nix;

let
  lib = import ../default.nix;
  setTypesAssert = type: pred:
    mapAttrs (name: value:
      #assert pred value;
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
    windows-nt = {};
    dos = {};
  };

  isKernel = x: isType "kernel" x;
  kernels = with execFormats; with kernelFamilies; setTypesAssert "kernel"
    (x: isExecFormat x.execFormat && all isKernelFamily (attrValues x.families))
  {
    cygwin  = { execFormat = pe;      families = { inherit /*unix*/ windows-nt; }; };
    darwin  = { execFormat = macho;   families = { inherit unix; }; };
    freebsd = { execFormat = elf;     families = { inherit unix bsd; }; };
    linux   = { execFormat = elf;     families = { inherit unix; }; };
    netbsd  = { execFormat = elf;     families = { inherit unix bsd; }; };
    none    = { execFormat = unknown; families = { inherit unix; }; };
    openbsd = { execFormat = elf;     families = { inherit unix bsd; }; };
    solaris = { execFormat = elf;     families = { inherit unix; }; };
    win32   = { execFormat = pe;      families = { inherit dos; }; };
  };


  isAbi = isType "abi";
  abis = setTypes "abi" {
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
  isWindows = s: matchAttrs { kernel = { families = { inherit (kernelFamilies) windows-nt; }; }; } s
              || matchAttrs { kernel = { families = { inherit (kernelFamilies) dos; }; }; } s;


  mkSkeletonFromList = l: {
    "2" =    { cpu = elemAt l 0;                      kernel = elemAt l 1;                   };
    "4" =    { cpu = elemAt l 0; vendor = elemAt l 1; kernel = elemAt l 2; abi = elemAt l 3; };
    "3" = # Awkwards hacks, beware!
      if elemAt l 1 == "apple"
        then { cpu = elemAt l 0; vendor = "apple";    kernel = elemAt l 2;                   }
      else if (elemAt l 1 == "linux") || (elemAt l 2 == "gnu")
        then { cpu = elemAt l 0;                      kernel = elemAt l 1; abi = elemAt l 2; }
      else throw "Target specification with 3 components is ambiguous";
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
    getCpu = name:
      attrByPath [name] (throw "Unknown CPU type: ${name}")
        cpuTypes;
    getVendor = name:
      attrByPath [name] (throw "Unknown vendor: ${name}")
        vendors;
    getKernel = name:
      attrByPath [name] (throw "Unknown kernel: ${name}")
        kernels;
    getAbi = name:
      attrByPath [name] (throw "Unknown ABI: ${name}")
        abis;

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

  doubleFromSystem = { cpu, vendor, kernel, abi, ... }: "${cpu.name}-${kernel.name}";

  tripleFromSystem = { cpu, vendor, kernel, abi, ... } @ sys: assert isSystem sys; let
    optAbi = lib.optionalString (abi != abis.unknown) "-${abi.name}";
  in "${cpu.name}-${vendor.name}-${kernel.name}${optAbi}";

}
