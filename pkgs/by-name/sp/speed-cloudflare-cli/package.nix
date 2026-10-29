{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  applyPatches,
  fetchpatch,
  nodejs,
}:
buildNpmPackage {
  pname = "speed-cloudflare-cli";
  version = "2.0.3-unstable-2025-07-31";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "KNawm";
      repo = "speed-cloudflare-cli";
      rev = "8eb34f4bd4f63493fbd93b1659389b9a1e5e4a36";
      sha256 = "sha256-kJ//zXBW2IQ5V5dJfAm8iGxf9QILH0uloNYiwG3pTe4=";
    };

    # Applies the follwing PR:
    # https://github.com/KNawm/speed-cloudflare-cli/pull/38
    patches = [
      # fix: handle non-array response from /locations and format
      (fetchpatch {
        url = "https://github.com/KNawm/speed-cloudflare-cli/commit/2682f167a1776de2f0c8085b591b06319a2aac7d.patch";
        hash = "sha256-pkGNg7NwSP9QrBI2e0q44ZyJ8ckp0Pw/brpDkZkevdk=";
      })
      # docs: add logging for API errors as suggested by code review
      (fetchpatch {
        url = "https://github.com/KNawm/speed-cloudflare-cli/commit/2cb89f9b9af0f43c75ed2ea8f6c0a8519766b7c8.patch";
        hash = "sha256-tLkyfXYd1s4FaMOwffyyObXZyIFlkvWvy7YkqBxU1SU=";
      })
    ];
  };

  postInstall = ''
    mkdir -p "$out/bin"

    # Create an executable wrapper
    makeWrapper ${lib.getExe nodejs} "$out/bin/speed-cloudflare-cli" \
      --add-flags "$out/lib/node_modules/speed-cloudflare-cli/cli.js"
  '';

  npmDepsHash = "sha256-CoirJgdpF9WEgbaXQbq5QlRO9wstZbNxIW2L1cJ+nXg=";

  dontBuild = true;
  dontNpmBuild = true;

  meta = {
    description = "Measure the speed and consistency of your internet connection using speed.cloudflare.com";
    homepage = "https://github.com/KNawm/speed-cloudflare-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ TheColorman ];
    mainProgram = "speed-cloudflare-cli";
    inherit (nodejs.meta) platforms;
  };
}
