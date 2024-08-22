{ callPackage, fetchurl }:

let
  buildBun = callPackage ./bun.nix { };
in
buildBun rec {
  version = "1.1.20";
  sources = {
    "aarch64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
      hash = "sha256-ErutjiXBjC9GDvb0F39AgbbsSo6zhRzpDEvDor/xRbI=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-aarch64.zip";
      hash = "sha256-vqL/H5t0elgT9fSk0Op7Td69eP9WPY2XVo1a8sraTwM=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64.zip";
      hash = "sha256-NIlpNEVTJdcRKvJbayIlMykEA1PDIcHj0uhBjX0xWqc=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
      hash = "sha256-bLcK0DSaLOzJSrIRPNHQeld5qud8ccqxzyDIgawMB3U=";
    };
  };
  baseline = buildBun {
    inherit version;
    sources = {
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64-baseline.zip";
        hash = "sha256-5PLk8q3di5TW8HUfo7P3xrPWLhleAiSv9jp2XeL47Kk=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
        hash = "sha256-KKPzGMTsH7mKo6VSDo7UCShpm5jvvER4MCXO30al1L8=";
      };
    };
  };
}
