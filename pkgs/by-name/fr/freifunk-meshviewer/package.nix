{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage (finalAttrs: {
  pname = "freifunk-meshviewer";

  version = "13.1.0";

  src = fetchFromGitHub {
    owner = "freifunk";
    repo = "meshviewer";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-u9lX7B402KFOHyaReyg3f5rDYDshbO/lyMYo7XxgJR8=";
  };

  npmDepsHash = "sha256-BaFtFdOu+WArH75nPtasSpecdGjMxTchFcF+K7krNpM=";

  installPhase = ''
    mkdir -p $out/share/freifunk-meshviewer/
    cp -r build/* $out/share/freifunk-meshviewer/
  '';

  meta = {
    homepage = "https://github.com/freifunk/meshviewer";
    changelog = "https://github.com/freifunk/meshviewer/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      felixsinger
    ];
    license = lib.licenses.agpl3Only;
  };
})
