{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "qdrant-web-ui";
  version = "0.1.29";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant-web-ui";
    rev = "refs/tags/v${version}";
    hash = "sha256-ni+78odD4PnkqlIzTpHsu16Lk6m9ql/Bq8Bm2qWxHj0=";
  };

  npmDepsHash = "sha256-Lg4nNw6wKb5tBUPCIUbriExQs3LKsF0bCCY3S136Epk=";

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
