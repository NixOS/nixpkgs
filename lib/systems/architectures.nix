{ lib }:

rec {
  # platform.gcc.arch to its features (as in /proc/cpuinfo)
  features = {
    default        = [ ];
    # x86_64 Intel
    westmere       = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes"                                    ];
    sandybridge    = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx"                              ];
    ivybridge      = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx"                              ];
    haswell        = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2"          "fma"        ];
    broadwell      = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2"          "fma"        ];
    skylake        = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2"          "fma"        ];
    skylake-avx512 = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2" "avx512" "fma"        ];
    # x86_64 AMD
    btver1         = [ "sse3" "ssse3" "sse4_1" "sse4_2"                                                  ];
    btver2         = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx"                              ];
    bdver1         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx"                 "fma" "fma4" ];
    bdver2         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx"                 "fma" "fma4" ];
    bdver3         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx"                 "fma" "fma4" ];
    bdver4         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx" "avx2"          "fma" "fma4" ];
    znver1         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx" "avx2"          "fma"        ];
    znver2         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx" "avx2"          "fma"        ];
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
    # x86_64 Intel
    default        = [ ];
    westmere       = [ ];
    sandybridge    = [ "westmere"    ] ++ inferiors.westmere;
    ivybridge      = [ "sandybridge" ] ++ inferiors.sandybridge;
    haswell        = [ "ivybridge"   ] ++ inferiors.ivybridge;
    broadwell      = [ "haswell"     ] ++ inferiors.haswell;
    skylake        = [ "broadwell"   ] ++ inferiors.broadwell;
    skylake-avx512 = [ "skylake"     ] ++ inferiors.skylake;
    # x86_64 AMD
    btver1         = [ ];
    btver2         = [ ]; # TODO: fill this (need testing)
    bdver1         = [ ]; # TODO: fill this (need testing)
    bdver2         = [ ]; # TODO: fill this (need testing)
    bdver3         = [ ]; # TODO: fill this (need testing)
    bdver4         = [ ]; # TODO: fill this (need testing)
    znver1         = [ ]; # TODO: fill this (need testing)
    znver2         = [ ]; # TODO: fill this (need testing)
    # other
    armv5te        = [ ];
    armv6          = [ ];
    armv7-a        = [ ];
    armv8-a        = [ ];
    mips32         = [ ];
    loongson2f     = [ ];
  };

  predicates = rec {
    featureSupport = feature: x: builtins.elem feature features.${x};
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
