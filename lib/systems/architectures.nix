{ lib }:

rec {
  # gcc.arch to its features (as in /proc/cpuinfo)
  features = {
    # x86_64 Generic
    # Spec: https://gitlab.com/x86-psABIs/x86-64-ABI/
    default        = [ ];
    x86-64         = [ ];
    x86-64-v2      = [ "sse3" "ssse3" "sse4_1" "sse4_2"                                                  ];
    x86-64-v3      = [ "sse3" "ssse3" "sse4_1" "sse4_2"               "avx" "avx2"          "fma"        ];
    x86-64-v4      = [ "sse3" "ssse3" "sse4_1" "sse4_2"               "avx" "avx2" "avx512" "fma"        ];
    # x86_64 Intel
    nehalem        = [ "sse3" "ssse3" "sse4_1" "sse4_2"                                                  ];
    westmere       = [ "sse3" "ssse3" "sse4_1" "sse4_2"                                                  ];
    silvermont     = [ "sse3" "ssse3" "sse4_1" "sse4_2"                                                  ];
    sandybridge    = [ "sse3" "ssse3" "sse4_1" "sse4_2"               "avx"                              ];
    ivybridge      = [ "sse3" "ssse3" "sse4_1" "sse4_2"               "avx"                              ];
    haswell        = [ "sse3" "ssse3" "sse4_1" "sse4_2"               "avx" "avx2"          "fma"        ];
    broadwell      = [ "sse3" "ssse3" "sse4_1" "sse4_2"               "avx" "avx2"          "fma"        ];
    skylake        = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2"          "fma"        ];
    skylake-avx512 = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2" "avx512" "fma"        ];
    cannonlake     = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2" "avx512" "fma"        ];
    icelake-client = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2" "avx512" "fma"        ];
    icelake-server = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2" "avx512" "fma"        ];
    cascadelake    = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2" "avx512" "fma"        ];
    cooperlake     = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2" "avx512" "fma"        ];
    tigerlake      = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2" "avx512" "fma"        ];
    alderlake      = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2"          "fma"        ];
    sapphirerapids = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2" "avx512" "fma"        ];
    emeraldrapids  = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2" "avx512" "fma"        ];
    # x86_64 AMD
    btver1         = [ "sse3" "ssse3" "sse4_1" "sse4_2"                                                  ];
    btver2         = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx"                              ];
    bdver1         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx"                 "fma" "fma4" ];
    bdver2         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx"                 "fma" "fma4" ];
    bdver3         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx"                 "fma" "fma4" ];
    bdver4         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx" "avx2"          "fma" "fma4" ];
    znver1         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx" "avx2"          "fma"        ];
    znver2         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx" "avx2"          "fma"        ];
    znver3         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx" "avx2"          "fma"        ];
    znver4         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx" "avx2" "avx512" "fma"        ];
    # other
    armv5te        = [ ];
    armv6          = [ ];
    armv7-a        = [ ];
    armv8-a        = [ ];
    mips32         = [ ];
    loongson2f     = [ ];
  };

  # a superior CPU has all the features of an inferior and is able to build and test code for it
  inferiors = {
    # x86_64 Generic
    default   = [ ];
    x86-64    = [ ];
    x86-64-v2 = [ "x86-64"    ];
    x86-64-v3 = [ "x86-64-v2" ] ++ inferiors.x86-64-v2;
    x86-64-v4 = [ "x86-64-v3" ] ++ inferiors.x86-64-v3;

    # x86_64 Intel
    # https://gcc.gnu.org/onlinedocs/gcc/x86-Options.html
    nehalem        = [ "x86-64-v2"   ] ++ inferiors.x86-64-v2;
    westmere       = [ "nehalem"     ] ++ inferiors.nehalem;
    sandybridge    = [ "westmere"    ] ++ inferiors.westmere;
    ivybridge      = [ "sandybridge" ] ++ inferiors.sandybridge;

    haswell        = lib.unique ([ "ivybridge" "x86-64-v3" ] ++ inferiors.ivybridge ++ inferiors.x86-64-v3);
    broadwell      = [ "haswell"   ] ++ inferiors.haswell;
    skylake        = [ "broadwell" ] ++ inferiors.broadwell;

    skylake-avx512 = lib.unique ([ "skylake" "x86-64-v4" ] ++ inferiors.skylake ++ inferiors.x86-64-v4);
    cannonlake     = [ "skylake-avx512" ] ++ inferiors.skylake-avx512;
    icelake-client = [ "cannonlake"     ] ++ inferiors.cannonlake;
    icelake-server = [ "icelake-client" ] ++ inferiors.icelake-client;
    cascadelake    = [ "cannonlake"     ] ++ inferiors.cannonlake;
    cooperlake     = [ "cascadelake"    ] ++ inferiors.cascadelake;
    tigerlake      = [ "icelake-server" ] ++ inferiors.icelake-server;
    sapphirerapids = [ "tigerlake"      ] ++ inferiors.tigerlake;
    emeraldrapids  = [ "sapphirerapids" ] ++ inferiors.sapphirerapids;

    # CX16 does not exist on alderlake, while it does on nearly all other intel CPUs
    alderlake      = [ ];

    # x86_64 AMD
    # TODO: fill this (need testing)
    btver1         = [ ];
    btver2         = [ ];
    bdver1         = [ ];
    bdver2         = [ ];
    bdver3         = [ ];
    bdver4         = [ ];
    # Regarding `skylake` as inferior of `znver1`, there are reports of
    # successful usage by Gentoo users and Phoronix benchmarking of different
    # `-march` targets.
    #
    # The GCC documentation on extensions used and wikichip documentation
    # regarding supperted extensions on znver1 and skylake was used to create
    # this partial order.
    #
    # Note:
    #
    # - The successors of `skylake` (`cannonlake`, `icelake`, etc) use `avx512`
    #   which no current AMD Zen michroarch support.
    # - `znver1` uses `ABM`, `CLZERO`, `CX16`, `MWAITX`, and `SSE4A` which no
    #   current Intel microarch support.
    #
    # https://www.phoronix.com/scan.php?page=article&item=amd-znver3-gcc11&num=1
    # https://gcc.gnu.org/onlinedocs/gcc/x86-Options.html
    # https://en.wikichip.org/wiki/amd/microarchitectures/zen
    # https://en.wikichip.org/wiki/intel/microarchitectures/skylake
    znver1         = [ "skylake" ] ++ inferiors.skylake; # Includes haswell and x86-64-v3
    znver2         = [ "znver1"  ] ++ inferiors.znver1;
    znver3         = [ "znver2"  ] ++ inferiors.znver2;
    znver4         = lib.unique ([ "znver3" "x86-64-v4" ] ++ inferiors.znver3 ++ inferiors.x86-64-v4);

    # other
    armv5te        = [ ];
    armv6          = [ ];
    armv7-a        = [ ];
    armv8-a        = [ ];
    mips32         = [ ];
    loongson2f     = [ ];
  };

  predicates = let
    featureSupport = feature: x: builtins.elem feature features.${x} or [];
  in {
    sse3Support    = featureSupport "sse3";
    ssse3Support   = featureSupport "ssse3";
    sse4_1Support  = featureSupport "sse4_1";
    sse4_2Support  = featureSupport "sse4_2";
    sse4_aSupport  = featureSupport "sse4a";
    avxSupport     = featureSupport "avx";
    avx2Support    = featureSupport "avx2";
    avx512Support  = featureSupport "avx512";
    aesSupport     = featureSupport "aes";
    fmaSupport     = featureSupport "fma";
    fma4Support    = featureSupport "fma4";
  };
}
