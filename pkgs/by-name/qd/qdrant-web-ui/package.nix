{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "qdrant-web-ui";
  version = "0.1.32";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant-web-ui";
    rev = "refs/tags/v${version}";
    hash = "sha256-iiaWFOqIf5TzJBfp2gINL8kgqbEoYRCjj0lcFP8rPkQ=";
  };

  npmDepsHash = "sha256-y2zTdRPU0nDCi7CcgyrdFec62qLXR8iXn7//Ys+xb8A=";

  npmBuildScript = "build-qdrant";

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
    maintainers = with lib.maintainers; [ xzfc ];
    platforms = lib.platforms.all;
  };
}
