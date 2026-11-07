{
  buildNpmPackage,
  fetchFromGitHub,
  fetchurl,
  lib,
  nixosTests,
}:
buildNpmPackage rec {
  pname = "qdrant-web-ui";
  version = "0.2.20";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant-web-ui";
    tag = "v${version}";
    hash = "sha256-Z1MCPGM4TFtaydZfyFs2Xr00x3W+kPKKGcuuiqJoF8A=";
  };

  # Restore missing lockfile URLs and integrity hashes.
  # https://github.com/qdrant/qdrant-web-ui/pull/453
  postPatch = ''
    cp ${
      fetchurl {
        url = "https://raw.githubusercontent.com/qdrant/qdrant-web-ui/8682e0c2bfb21e2470bfa7f37e7611e8e3ea1847/package-lock.json";
        hash = "sha256-r5kkzFI/PwwRvXlxIUiMSz7rTl9xVWfrxoaiflMQ0go=";
      }
    } package-lock.json
  '';

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-mwPwtu05vZHwikiF5fwP9tg5gJfWosThfHm5nLh++ko=";

  npmBuildScript = "build-qdrant";
  npmFlags = [ "--legacy-peer-deps" ];

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) qdrant; };

  meta = {
    description = "Self-hosted web UI for Qdrant";
    homepage = "https://github.com/qdrant/qdrant-web-ui";
    changelog = "https://github.com/qdrant/qdrant-web-ui/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      xzfc
      patrickdag
    ];
    platforms = lib.platforms.all;
  };
}
