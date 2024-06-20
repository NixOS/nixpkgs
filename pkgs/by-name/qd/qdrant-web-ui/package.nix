{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "qdrant-web-ui";
  version = "0.1.28";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant-web-ui";
    rev = "refs/tags/v${version}";
    hash = "sha256-jbr1PdoYcBxT7EOksLOPYNGz+GG5HVG406S+GRyWeiE=";
  };

  npmDepsHash = "sha256-8sk2QyunSrKE5/kjSoo0whdVbY9IXCF+n7ZIjP4Mgq8=";

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
