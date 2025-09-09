{ callPackage, fetchurl }:

let
  buildBun = callPackage ./bun.nix { };
in
buildBun rec {
  version = "1.2.21";
  sources = {
    "aarch64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
      hash = "sha256-/YhmMLoVxIQjatXz8islXSh8Pu+NO8JvyAmFEDXATOw=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-aarch64.zip";
      hash = "sha256-DkyeVIdqFg6RgSrjxi02z71o8g4VjLcy9joNa3WUKHs=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64-baseline.zip";
      hash = "sha256-Qm1N3h5Rg0aNMf+G7RPAjW8p7wlcia5QtfX1IP3u2RY=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
      hash = "sha256-WU9FTVHOVxmdQyDIXL1JW+nAVO8XquvKXmyQir/aYXk=";
    };
  };
  baseline = buildBun {
    inherit version;
    sources = {
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64-baseline.zip";
        hash = "sha256-Qm1N3h5Rg0aNMf+G7RPAjW8p7wlcia5QtfX1IP3u2RY=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
        hash = "sha256-t79LU6V8jcPRWJIizgoq+QIQ9yDSqKeVEqPmAbeTWQo=";
      };
    };
  };
}
