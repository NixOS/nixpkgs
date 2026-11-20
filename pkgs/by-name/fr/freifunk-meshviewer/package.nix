{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage (finalAttrs: {
  pname = "freifunk-meshviewer";

  version = "14.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "freifunk";
    repo = "meshviewer";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-J1QvXF39H3oiJwmKYqQq/QoRq3ZUI9AlfaRkehmnxEU=";
  };

  npmDepsHash = "sha256-qlOWxAgcOMKhc4FcBdvtxmadMtaDwnjQgYRnnIwYM00=";

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
