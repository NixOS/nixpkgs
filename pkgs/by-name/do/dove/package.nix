{
  lib,
  fetchzip,
  stdenvNoCC,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dove";
  version = "2025.02.14.1";

  src = fetchzip {
    url = "https://codeberg.org/celenity/Dove/raw/tag/${finalAttrs.version}/archives/dove.zip";
    hash = "sha256-v/CLEt8QNAZYkKAsabdVgTVBdMtbA4+6w92LBSC95yY=";
    stripRoot = false;
    # general.config.filename is hard-coded to mozilla.cfg in wrapFirefox, so removing this setting:
    postFetch = ''
      sed -i '/general.config.filename/d' $out/dove.cfg $out/prefs/dove.js
    '';
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r $src/policies.json $src/dove.cfg $src/prefs $out/
    install -Dm644 $src/README.md $out/share/doc/dove/README.md

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
