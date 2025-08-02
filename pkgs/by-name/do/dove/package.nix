{
  lib,
  stdenv,
  fetchzip,
  stdenvNoCC,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dove";
  version = "2025.02.21.1";

  src =
    if stdenv.isDarwin then
      fetchzip {
        url = "https://codeberg.org/celenity/Dove/raw/tag/${finalAttrs.version}/archives/dove-osx.zip";
        hash = "sha256-kgboCDCQjVqJaGWNffTjuuMWjZH1xucWic2R9CLrjx0=";
        stripRoot = false;
      }
    else
      fetchzip {
        url = "https://codeberg.org/celenity/Dove/raw/tag/${finalAttrs.version}/archives/dove.zip";
        hash = "sha256-wlFC9TMlMqMYCTFSiJ0JUUKi3hd6vRcNRovkAh3BSps=";
        stripRoot = false;
        # general.config.filename is hard-coded to mozilla.cfg in wrapFirefox, so removing this setting:
        postFetch = ''
          sed -i '/general.config.filename/d' $out/prefs/dove.js
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
        ''
      else
        ''
          cp -r $src/policies.json $src/dove.cfg $src/prefs $out/
        ''
    }
    install -Dm644 $src/README.md $out/share/doc/dove/README.md
    install -Dm644 $src/COPYING $out/share/doc/dove/COPYING

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A suite of configurations & advanced modifications for Mozilla Thunderbird with a focus on privacy, security, freedom, & usability";
    homepage = "https://dove.celenity.dev/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      jbgi
    ];
    platforms = lib.platforms.all;
  };
})
