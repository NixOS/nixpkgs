{ callPackage, fetchurl }:

let
  buildBun = callPackage ./bun.nix { };
in
buildBun rec {
  version = "1.1.10";
  sources = {
    "aarch64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
      hash = "sha256-txTr+uYvGOsytyTO2mXZUQOOJMcNT4uyzNCdz4pn0AQ=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-aarch64.zip";
      hash = "sha256-8Wp3RDvP2/tonU8ngDTWuGD1m7q7gxwnuwbxpc6N/+Y=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64.zip";
      hash = "sha256-cV3NO0qGqZqSgVLj1U2bvQUqGzgGugLPwk4eq+XfjTU=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
      hash = "sha256-iQM/BtoaDBRlH/jx9qH6WlV2Ox7MbtWMzHc8RxVCHH0=";
    };
  };
  baseline = buildBun {
    inherit version;
    sources = {
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64-baseline.zip";
        hash = "sha256-We4eENZtGmxv47y9p9dvmbNHbUUW5WubHT/HwTUUajU=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
        hash = "sha256-hWqAMCCifKIdn8nAoTRX+E49XYIxbyoGHcK09TQT6B0=";
      };
    };
  };
}
