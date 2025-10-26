{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage (finalAttrs: {
  pname = "freifunk-meshviewer";

  version = "12.6.0";

  src = fetchFromGitHub {
    owner = "freifunk";
    repo = "meshviewer";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-h+0f6RwJip3V7XJ8q8eEov2k09wNwdHOJgR2XUZqkgw=";
  };

  npmDepsHash = "sha256-QgUEoUF2qEtplx2YaMO81g9cY7a+oXCX5dF6V54waD8=";

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
