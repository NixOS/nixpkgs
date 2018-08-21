{ lib }:
with import ./parse.nix { inherit lib; };
with lib.attrsets;
with lib.lists;

let abis_ = abis; in
let abis = lib.mapAttrs (_: abi: builtins.removeAttrs abi [ "assertions" ]) abis_; in

rec {
  patterns = rec {
    isi686         = { cpu = cpuTypes.i686; };
    isx86_64       = { cpu = cpuTypes.x86_64; };
    isPowerPC      = { cpu = cpuTypes.powerpc; };
    isPower = { cpu = { family = "power"; }; };
    isx86          = { cpu = { family = "x86"; }; };
    isAarch32      = { cpu = { family = "arm"; bits = 32; }; };
    isAarch64      = { cpu = { family = "arm"; bits = 64; }; };
    isMips         = { cpu = { family = "mips"; }; };
    isRiscV        = { cpu = { family = "riscv"; }; };
    isSparc        = { cpu = { family = "sparc"; }; };
    isWasm         = { cpu = { family = "wasm"; }; };

    is32bit        = { cpu = { bits = 32; }; };
    is64bit        = { cpu = { bits = 64; }; };
    isBigEndian    = { cpu = { significantByte = significantBytes.bigEndian; }; };
    isLittleEndian = { cpu = { significantByte = significantBytes.littleEndian; }; };

    isBSD          = { kernel = { families = { inherit (kernelFamilies) bsd; }; }; };
    isDarwin       = { kernel = { families = { inherit (kernelFamilies) darwin; }; }; };
    isUnix         = [ isBSD isDarwin isLinux isSunOS isHurd isCygwin ];

    isMacOS        = { kernel = kernels.macos; };
    isiOS          = { kernel = kernels.ios; };
    isLinux        = { kernel = kernels.linux; };
    isSunOS        = { kernel = kernels.solaris; };
    isFreeBSD      = { kernel = kernels.freebsd; };
    isHurd         = { kernel = kernels.hurd; };
    isNetBSD       = { kernel = kernels.netbsd; };
    isOpenBSD      = { kernel = kernels.openbsd; };
    isWindows      = { kernel = kernels.windows; };
    isCygwin       = { kernel = kernels.windows; abi = abis.cygnus; };
    isMinGW        = { kernel = kernels.windows; abi = abis.gnu; };

    isAndroid      = [ { abi = abis.android; } { abi = abis.androideabi; } ];
    isMusl         = with abis; map (a: { abi = a; }) [ musl musleabi musleabihf ];
    isUClibc       = with abis; map (a: { abi = a; }) [ uclibc uclibceabi uclibceabihf ];

    isEfi          = map (family: { cpu.family = family; })
                       [ "x86" "arm" "aarch64" ];

    # Deprecated after 18.03
    isArm = isAarch32;
  };

  matchAnyAttrs = patterns:
    if builtins.isList patterns then attrs: any (pattern: matchAttrs pattern attrs) patterns
    else matchAttrs patterns;

  predicates = mapAttrs (_: matchAnyAttrs) patterns;
}
