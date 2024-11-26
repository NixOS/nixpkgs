{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "qdrant-web-ui";
  version = "0.1.33";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant-web-ui";
    rev = "refs/tags/v${version}";
    hash = "sha256-ij/+qRTmG8WBanFiO8blsnI51l/ehS7bllmO2K3onA4=";
  };

  npmDepsHash = "sha256-ed/rHD3bE9izva+Vl7WINaRhCjOapvdl5intCRYDXTY=";

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
