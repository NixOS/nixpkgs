{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "qdrant-web-ui";
  version = "0.1.30";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant-web-ui";
    rev = "refs/tags/v${version}";
    hash = "sha256-bHE/ZBc1PvjnIXhkh9BFS0x3Urnh4LOHH4MoKgqVVJ4=";
  };

  npmDepsHash = "sha256-3w3imfe9XbK3eSh6kOd2G/ei75+Ub08L/hBej1iy9R4=";

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
