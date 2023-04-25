{ lib }:
with import ./parse.nix { inherit lib; };
with lib.attrsets;
with lib.lists;

let abis_ = abis; in
let abis = lib.mapAttrs (_: abi: builtins.removeAttrs abi [ "assertions" ]) abis_; in

rec {
  # these patterns are to be matched against {host,build,target}Platform.parsed
  patterns = rec {
    # The patterns below are lists in sum-of-products form.
    #
    # Each attribute is list of product conditions; non-list values are treated
    # as a singleton list.  If *any* product condition in the list matches then
    # the predicate matches.  Each product condition is tested by
    # `lib.attrsets.matchAttrs`, which requires a match on *all* attributes of
    # the product.

    isi686         = { cpu = cpuTypes.i686; };
    isx86_32       = { cpu = { family = "x86"; bits = 32; }; };
    isx86_64       = { cpu = { family = "x86"; bits = 64; }; };
    isPower        = { cpu = { family = "power"; }; };
    isPower64      = { cpu = { family = "power"; bits = 64; }; };
    # This ABI is the default in NixOS PowerPC64 BE, but not on mainline GCC,
    # so it sometimes causes issues in certain packages that makes the wrong
    # assumption on the used ABI.
    isAbiElfv2 = [
      { abi = { abi = "elfv2"; }; }
      { abi = { name = "musl"; }; cpu = { family = "power"; bits = 64; }; }
    ];
    isx86          = { cpu = { family = "x86"; }; };
    isAarch32      = { cpu = { family = "arm"; bits = 32; }; };
    isArmv7        = map ({ arch, ... }: { cpu = { inherit arch; }; })
                       (lib.filter (cpu: lib.hasPrefix "armv7" cpu.arch or "")
                         (lib.attrValues cpuTypes));
    isAarch64      = { cpu = { family = "arm"; bits = 64; }; };
    isAarch        = { cpu = { family = "arm"; }; };
    isMicroBlaze   = { cpu = { family = "microblaze"; }; };
    isMips         = { cpu = { family = "mips"; }; };
    isMips32       = { cpu = { family = "mips"; bits = 32; }; };
    isMips64       = { cpu = { family = "mips"; bits = 64; }; };
    isMips64n32    = { cpu = { family = "mips"; bits = 64; }; abi = { abi = "n32"; }; };
    isMips64n64    = { cpu = { family = "mips"; bits = 64; }; abi = { abi = "64";  }; };
    isMmix         = { cpu = { family = "mmix"; }; };
    isRiscV        = { cpu = { family = "riscv"; }; };
    isRiscV32      = { cpu = { family = "riscv"; bits = 32; }; };
    isRiscV64      = { cpu = { family = "riscv"; bits = 64; }; };
    isRx           = { cpu = { family = "rx"; }; };
    isSparc        = { cpu = { family = "sparc"; }; };
    isWasm         = { cpu = { family = "wasm"; }; };
    isMsp430       = { cpu = { family = "msp430"; }; };
    isVc4          = { cpu = { family = "vc4"; }; };
    isAvr          = { cpu = { family = "avr"; }; };
    isAlpha        = { cpu = { family = "alpha"; }; };
    isOr1k         = { cpu = { family = "or1k"; }; };
    isM68k         = { cpu = { family = "m68k"; }; };
    isS390         = { cpu = { family = "s390"; }; };
    isS390x        = { cpu = { family = "s390"; bits = 64; }; };
    isJavaScript   = { cpu = cpuTypes.javascript; };

    is32bit        = { cpu = { bits = 32; }; };
    is64bit        = { cpu = { bits = 64; }; };
    isILP32        = map (a: { abi = { abi = a; }; }) [ "n32" "ilp32" "x32" ];
    isBigEndian    = { cpu = { significantByte = significantBytes.bigEndian; }; };
    isLittleEndian = { cpu = { significantByte = significantBytes.littleEndian; }; };

    isBSD          = { kernel = { families = { inherit (kernelFamilies) bsd; }; }; };
    isDarwin       = { kernel = { families = { inherit (kernelFamilies) darwin; }; }; };
    isUnix         = [ isBSD isDarwin isLinux isSunOS isCygwin isRedox ];

    isMacOS        = { kernel = kernels.macos; };
    isiOS          = { kernel = kernels.ios; };
    isLinux        = { kernel = kernels.linux; };
    isSunOS        = { kernel = kernels.solaris; };
    isFreeBSD      = { kernel = { name = "freebsd"; }; };
    isNetBSD       = { kernel = kernels.netbsd; };
    isOpenBSD      = { kernel = kernels.openbsd; };
    isWindows      = { kernel = kernels.windows; };
    isCygwin       = { kernel = kernels.windows; abi = abis.cygnus; };
    isMinGW        = { kernel = kernels.windows; abi = abis.gnu; };
    isWasi         = { kernel = kernels.wasi; };
    isRedox        = { kernel = kernels.redox; };
    isGhcjs        = { kernel = kernels.ghcjs; };
    isGenode       = { kernel = kernels.genode; };
    isNone         = { kernel = kernels.none; };

    isAndroid      = [ { abi = abis.android; } { abi = abis.androideabi; } ];
    isGnu          = with abis; map (a: { abi = a; }) [ gnuabi64 gnu gnueabi gnueabihf gnuabielfv1 gnuabielfv2 ];
    isMusl         = with abis; map (a: { abi = a; }) [ musl musleabi musleabihf muslabin32 muslabi64 ];
    isUClibc       = with abis; map (a: { abi = a; }) [ uclibc uclibceabi uclibceabihf ];

    isEfi = [
      { cpu = { family = "arm"; version = "6"; }; }
      { cpu = { family = "arm"; version = "7"; }; }
      { cpu = { family = "arm"; version = "8"; }; }
      { cpu = { family = "riscv"; }; }
      { cpu = { family = "x86"; }; }
    ];
  };

  matchAnyAttrs = patterns:
    if builtins.isList patterns then attrs: any (pattern: matchAttrs pattern attrs) patterns
    else matchAttrs patterns;

  predicates = mapAttrs (_: matchAnyAttrs) patterns;

  # these patterns are to be matched against the entire
  # {host,build,target}Platform structure; they include a `parsed={}` marker so
  # that `lib.meta.availableOn` can distinguish them from the patterns which
  # apply only to the `parsed` field.

  platformPatterns = mapAttrs (_: p: { parsed = {}; } // p) {
    isStatic = { isStatic = true; };
  };
}
