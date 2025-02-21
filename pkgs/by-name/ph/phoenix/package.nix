{
  lib,
  fetchzip,
  stdenvNoCC,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "phoenix";
  version = "2025.02.14.1";

  src = fetchzip {
    url = "https://codeberg.org/celenity/Phoenix/raw/tag/${finalAttrs.version}/archives/phoenix.zip";
    hash = "sha256-iBWkbUh8XXxPapqpdwmKsl1wwuLki1fT5u4Sovwv1ac=";
    stripRoot = false;
    # general.config.filename is hard-coded to mozilla.cfg in wrapFirefox, so removing this setting:
    postFetch = ''
      sed -i '/general.config.filename/d' $out/phoenix.cfg $out/prefs/phoenix-desktop.js
    '';
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r $src/userjs/linux $out/userjs
    cp -r $src/policies.json $src/phoenix.cfg $src/prefs $src/configs $out/
    install -Dm644 $src/README.md $out/share/doc/phoenix/README.md

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A suite of configurations & advanced modifications for Mozilla Firefox with a focus on privacy, security, freedom, & usability";
    homepage = "https://phoenix.celenity.dev";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      jbgi
    ];
    platforms = lib.platforms.all;
  };
})
