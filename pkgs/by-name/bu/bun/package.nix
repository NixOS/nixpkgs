{ callPackage, fetchurl }:

let
  buildBun = callPackage ./bun.nix { };
in
buildBun rec {
  version = "1.2.22";
  sources = {
    "aarch64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
      hash = "sha256-64x+CcvqVyQUoKNnhI4ay/BSlKlGpZRAWgFLH7Oz/HY=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-aarch64.zip";
      hash = "sha256-qXxof7XlTeTi+whpp6yaLZw691rBguK2gTjB3Y+YExs=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64-baseline.zip";
      hash = "sha256-58GgthtkZsbaKnJbPFGGT6BQomLSSJ8aEJ8nNkx0MnI=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
      hash = "sha256-TERq8aAde0Dh4RuuvDUvmyv9Eoh+Ubl907WYec7idDo=";
    };
  };
  baseline = buildBun {
    inherit version;
    sources = {
      # Linux-only: darwin already uses baseline
      "x86_64-linux" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
        hash = "sha256-91Po2WaAeKsPWY7iaprFrLu4IuBXRZ3VDBkbhlJNmOg=";
      };
    };
  };
}
