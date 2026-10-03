{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "qdrant-web-ui";
  version = "0.2.16";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant-web-ui";
    tag = "v${version}";
    hash = "sha256-hXNovsTjrAMyG4JhtwFsPme7IoZs7P6x1qpg97olGH0=";
  };

  npmDepsHash = "sha256-LNW8/dDD/5dleS/9PpFOxOdYkYLdt2r866GOZzuuU+E=";

  npmBuildScript = "build-qdrant";
  npmFlags = [ "--legacy-peer-deps" ];

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

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
