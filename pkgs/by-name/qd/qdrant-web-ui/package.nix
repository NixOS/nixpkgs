{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "qdrant-web-ui";
  version = "0.1.40";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant-web-ui";
    tag = "v${version}";
    hash = "sha256-fkgTQZ5172T/reUk9luv9lWON1gkRO6sXPUmfe6f4oc=";
  };

  npmDepsHash = "sha256-tET15Dcu8V7ssHgjC09w2zcFSU8Oyb0V+nlpptxmqjo=";

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
