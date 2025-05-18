{
  lib,
  stdenv,
  fetchzip,
  stdenvNoCC,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "phoenix";
  version = "2025.02.21.1";

  src =
    if stdenv.isDarwin then
      fetchzip {
        url = "https://codeberg.org/celenity/Phoenix/raw/tag/${finalAttrs.version}/archives/phoenix-osx.zip";
        hash = "sha256-OwQu5f19QDNVEM4y630vsPL43D3TU9Utlt592ADmJ7M=";
        stripRoot = false;
      }
    else
      fetchzip {
        url = "https://codeberg.org/celenity/Phoenix/raw/tag/${finalAttrs.version}/archives/phoenix.zip";
        hash = "sha256-YFziMQiw0xAcMfjHQacz42zYDg9OihordfD7kRqYgPo=";
        stripRoot = false;
        # general.config.filename is hard-coded to mozilla.cfg in wrapFirefox, so removing this setting:
        postFetch = ''
          sed -i '/general.config.filename/d' $out/prefs/phoenix-desktop.js
        '';
      };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    ${
      if stdenv.isDarwin then
        ''
          cp $src/macos/* $out/
          cp -r $src/configs/macos $out/configs
          cp -r $src/userjs/macos $out/userjs
        ''
      else
        ''
          cp -r $src/policies.json $src/phoenix.cfg $src/prefs $src/configs $out/
          cp -r $src/userjs/linux $out/userjs
        ''
    }
    install -Dm644 $src/COPYING $out/share/doc/phoenix/COPYING
    install -Dm644 $src/README.md $out/share/doc/phoenix/README.md
    install -Dm644 $src/userjs/README.md $out/share/doc/phoenix/userjs/README.md

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
