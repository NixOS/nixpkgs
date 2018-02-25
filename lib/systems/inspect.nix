{ lib }:
with import ./parse.nix { inherit lib; };
with lib.attrsets;
with lib.lists;

rec {
  patterns = rec {
    i686         = { cpu = cpuTypes.i686; };
    x86_64       = { cpu = cpuTypes.x86_64; };
    PowerPC      = { cpu = cpuTypes.powerpc; };
    x86          = { cpu = { family = "x86"; }; };
    Arm          = { cpu = { family = "arm"; }; };
    Aarch64      = { cpu = { family = "aarch64"; }; };
    Mips         = { cpu = { family = "mips"; }; };
    RiscV        = { cpu = { family = "riscv"; }; };
    Wasm         = { cpu = { family = "wasm"; }; };

    "32bit"      = { cpu = { bits = 32; }; };
    "64bit"      = { cpu = { bits = 64; }; };
    BigEndian    = { cpu = { significantByte = significantBytes.bigEndian; }; };
    LittleEndian = { cpu = { significantByte = significantBytes.littleEndian; }; };

    BSD          = { kernel = { families = { inherit (kernelFamilies) bsd; }; }; };
    Unix         = [ BSD Darwin Linux SunOS Hurd Cygwin ];

    Darwin       = { kernel = kernels.darwin; };
    Linux        = { kernel = kernels.linux; };
    SunOS        = { kernel = kernels.solaris; };
    FreeBSD      = { kernel = kernels.freebsd; };
    Hurd         = { kernel = kernels.hurd; };
    NetBSD       = { kernel = kernels.netbsd; };
    OpenBSD      = { kernel = kernels.openbsd; };
    Windows      = { kernel = kernels.windows; };
    Cygwin       = { kernel = kernels.windows; abi = abis.cygnus; };
    MinGW        = { kernel = kernels.windows; abi = abis.gnu; };

    Musl         = with abis; map (a: { abi = a; }) [ musl musleabi musleabihf ];

    Kexecable    = map (family: { kernel = kernels.linux; cpu.family = family; })
                     [ "x86" "arm" "aarch64" "mips" ];
    Efi          = map (family: { cpu.family = family; })
                     [ "x86" "arm" "aarch64" ];
    Seccomputable = map (family: { kernel = kernels.linux; cpu.family = family; })
                      [ "x86" "arm" "aarch64" "mips" ];
  };

  matchAnyAttrs = patterns:
    if builtins.isList patterns then attrs: any (pattern: matchAttrs pattern attrs) patterns
    else matchAttrs patterns;

  predicates = mapAttrs'
    (name: value: nameValuePair ("is" + name) (matchAnyAttrs value))
    patterns;
}
