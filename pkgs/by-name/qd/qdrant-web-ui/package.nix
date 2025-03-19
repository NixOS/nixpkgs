{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "qdrant-web-ui";
  version = "0.1.37";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant-web-ui";
    tag = "v${version}";
    hash = "sha256-Vp50kZwtlQ6IgxkS8cndupTU8WMWp9Juoc5CNbyYyXI=";
  };

  npmDepsHash = "sha256-6e6Ubfu5D9FJUc+IQ53KxQ1KmsHQXGqW4FXB1Uj15eE=";

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
