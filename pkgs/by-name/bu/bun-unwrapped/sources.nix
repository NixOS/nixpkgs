{ fetchurl }:

# Bun's URL-keyed cache consumes the original archives. fetchFromGitHub would
# unpack them, so keep these inputs as separate fetchurl derivations.
let
  download =
    name: url: hash:
    fetchurl {
      inherit url hash;
      name = "bun-${name}.tar.gz";
    };
in
[
  (download "picohttpparser"
    "https://github.com/h2o/picohttpparser/archive/066d2b1e9ab820703db0837a7255d92d30f0c9f5.tar.gz"
    "sha256-Y3/yq29cf34FpbXcOT1c8v6o1HVPys6q+TX//1wTI+4="
  )
  (download "zlib"
    "https://github.com/zlib-ng/zlib-ng/archive/12731092979c6d07f42da27da673a9f6c7b13586.tar.gz"
    "sha256-oNKl0SLIS1ank6FVOpwzJ/sut0ab96hreePHvl2S6NY="
  )
  (download "zstd"
    "https://github.com/facebook/zstd/archive/f8745da6ff1ad1e7bab384bd1f9d742439278e99.tar.gz"
    "sha256-SwvR8M+yXmG5EDw18nOVUw/1tMDSUToA/XRYSehepSw="
  )
  (download "brotli" "https://github.com/google/brotli/archive/v1.1.0.tar.gz"
    "sha256-5yCmyilCi4A/StFlNxdx9TmPq6OX7fZ3iDehhZnqE/8="
  )
  (download "libdeflate"
    "https://github.com/ebiggers/libdeflate/archive/c8c56a20f8f621e6a966b716b31f1dedab6a41e3.tar.gz"
    "sha256-HlzAa9vz4SRdi4nJ41iPUH48i8U/6Lgil3Cp6GYd6oE="
  )
  (download "libarchive"
    "https://github.com/libarchive/libarchive/archive/ded82291ab41d5e355831b96b0e1ff49e24d8939.tar.gz"
    "sha256-BC8O/nFHBj/5uhDxo47QgOlJvL0Evb81kriEbdEbHaI="
  )
  (download "libjpeg-turbo"
    "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/e352b02f794f701407b39af08576035ba3360d60.tar.gz"
    "sha256-RA86lDkMeOq4j3S5KUTS9rJI5ZLphEEuOJiF37V5a/A="
  )
  (download "libspng"
    "https://github.com/randy408/libspng/archive/fb768002d4288590083a476af628e51c3f1d47cd.tar.gz"
    "sha256-1laBMpDXCnULaedoMj/zs4da34wujC/bTlfKFGer+Go="
  )
  (download "libwebp"
    "https://github.com/webmproject/libwebp/archive/b7e29b9d75bd31422b00c2a446d49d7af06c328d.tar.gz"
    "sha256-dvuJtEVP8hYbsMyiz4MuGbi0ABsO9C+8wrSkN8lFsrY="
  )
  (download "cares"
    "https://github.com/c-ares/c-ares/archive/c7a3138dcfe3bb0eaaf10c0c24c36dc66dc790ab.tar.gz"
    "sha256-yeobMCmyOwQ3bCKb1RlInO4YCHTsSM2GOl3LpijA/gM="
  )
  (download "hdrhistogram"
    "https://github.com/HdrHistogram/HdrHistogram_c/archive/be60a9987ee48d0abf0d7b6a175bad8d6c1585d1.tar.gz"
    "sha256-gRxeWuUwOnWt5QaIiAr2qtXS+VHsV4X2gYa9GGNc38k="
  )
  (download "highway"
    "https://github.com/google/highway/archive/2607d3b5b0113992fe84d3848859eae13b3b52c1.tar.gz"
    "sha256-dB1wV4Hgs+QGvtqPH5lPuuATISN86AI6GtkPuveUDCU="
  )
  (download "lolhtml"
    "https://github.com/oven-sh/lol-html/archive/725ce499aa9b71e38b7a2d0a9fbb6d7294a4079e.tar.gz"
    "sha256-r9g+2+Gi1KzLcuhpzUIYu4Zl/aK3yyxRBvxL6AABp0g="
  )
  (download "rust-argon2"
    "https://github.com/sru-systems/rust-argon2/archive/ed81866f163f0c7026aa6fd8388adf37242eb32a.tar.gz"
    "sha256-53x5dETxkfr0iNScdsT0XBCz2SdeA2TuELbQXPvle68="
  )
  (download "lshpack"
    "https://github.com/litespeedtech/ls-hpack/archive/8905c024b6d052f083a3d11d0a169b3c2735c8a1.tar.gz"
    "sha256-B9i/kBuxsVVD846r0jk4UZ4SEO6621Lz1lHW7xMO+XM="
  )
  (download "lsqpack"
    "https://github.com/litespeedtech/ls-qpack/archive/1e9c5b8e59f8161c54f168a570c8bfdc59ded0c3.tar.gz"
    "sha256-6dir5bfB41uZCKlSHirNfB0XVHurwB1zxyl+Aq67zC0="
  )
  (download "mimalloc"
    "https://github.com/oven-sh/mimalloc/archive/6a14aee24315e503fa295a1fa90fe8b24ad91774.tar.gz"
    "sha256-D5q+An/kqplDwt81IwQ8aunrTIJB/rwAkbb1NyItJtg="
  )
  (download "tinycc"
    "https://github.com/oven-sh/tinycc/archive/05f0fafaa3be31e31d7b4b5c17dc60f62c991171.tar.gz"
    "sha256-UHUGgDEpI6Wf3TauQfcJHY415RkJ0OCyWwsz6pU0vAg="
  )
  (download "boringssl"
    "https://github.com/oven-sh/boringssl/archive/2288897e2e716330490893d226b4f079f9da9e0c.tar.gz"
    "sha256-bHqvDZn/NUdchnikNUP5TVX2jUlWxLc84BQX/DWM7+c="
  )
  (download "lsquic"
    "https://github.com/litespeedtech/lsquic/archive/3181911301b1aa4f54c1ed690901abc674ee08fb.tar.gz"
    "sha256-+MuQ+zJ+uRWXwjFjv1lsDRiCVgvjW2Ydm6hIkcxGFzU="
  )
  (download "nodejs-headers" "https://nodejs.org/dist/v26.3.0/node-v26.3.0-headers.tar.gz"
    "sha256-/KETxdWt2L+xqjESmiSsuNSappqzwiosxWmuyIlgUm0="
  )
]
