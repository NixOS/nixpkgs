with import ./parse.nix;
with import ../attrsets.nix;
with import ../lists.nix;

rec {
  patterns = rec {
    "32bit"      = { cpu = { bits = 32; }; };
    "64bit"      = { cpu = { bits = 64; }; };
    i686         = { cpu = cpuTypes.i686; };
    x86_64       = { cpu = cpuTypes.x86_64; };
    PowerPC      = { cpu = cpuTypes.powerpc; };
    x86          = { cpu = { family = "x86"; }; };
    Arm          = { cpu = { family = "arm"; }; };
    Mips         = { cpu = { family = "mips"; }; };
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

    Arm32        = recursiveUpdate Arm patterns."32bit";
    Arm64        = recursiveUpdate Arm patterns."64bit";
  };

  matchAnyAttrs = patterns:
    if builtins.isList patterns then attrs: any (pattern: matchAttrs pattern attrs) patterns
    else matchAttrs patterns;

  predicates = mapAttrs'
    (name: value: nameValuePair ("is" + name) (matchAnyAttrs value))
    patterns;
}
