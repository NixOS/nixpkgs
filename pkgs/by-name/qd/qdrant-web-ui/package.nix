{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "qdrant-web-ui";
  version = "0.1.35";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant-web-ui";
    tag = "v${version}";
    hash = "sha256-kTXN+uouEf/szksu+rLAXW+As2YyrFF4i8AluFEPRUs=";
  };

  npmDepsHash = "sha256-oZydAlmzNjjcuLtXfhBXrsuOBPyOsnRZZ7DzUVg0eas=";

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
