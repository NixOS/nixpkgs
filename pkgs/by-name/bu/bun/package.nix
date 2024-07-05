{ callPackage, fetchurl }:

let
  buildBun = callPackage ./bun.nix { };
in
buildBun rec {
  version = "1.1.17";
  sources = {
    "aarch64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
      hash = "sha256-aULgRZ9evcGUhKJ6slLJOg3IEzUeNfIkJF8RDP3YUlo=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-aarch64.zip";
      hash = "sha256-eytY45LcgeI9m9amHd8hfE7Lz7ET7p19h37Bi4yUHBM=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64.zip";
      hash = "sha256-bF/yg7C2tsdPjotC4DKISZRWEUUmUha22tWJynearEM=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
      hash = "sha256-pRggu/l0HgCk73kX7W43qKFVE13/7pP4P9bTiqyK2Yk=";
    };
  };
  baseline = buildBun {
    inherit version;
    sources = {
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64-baseline.zip";
        hash = "sha256-SKD/nJSDCPEQPekbkHkEew0mw2E55/L2hPjlz3fu3J8=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
        hash = "sha256-Lg4gMa1o0p0hfYHhi5DDvkzpsWHLOk+q1QezcWFATWY=";
      };
    };
  };
}
