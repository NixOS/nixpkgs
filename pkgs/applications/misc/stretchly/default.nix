{ stdenv
, lib
, fetchurl
, makeWrapper
, electron
, common-updater-scripts
, writeShellScript
, makeDesktopItem
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stretchly";
  version = "1.15.1";

  src = fetchurl {
    url = "https://github.com/hovancik/stretchly/releases/download/v${finalAttrs.version}/stretchly-${finalAttrs.version}.tar.xz";
    hash = "sha256-suTH6o7vtUr2DidPXAwqrya5/WukQOFmS/34LaiWDBs=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/hovancik/stretchly/v${finalAttrs.version}/stretchly_128x128.png";
    hash = "sha256-tO0cNKopG/recQus7KDUTyGpApvR5/tpmF5C4V14DnI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${finalAttrs.pname}/
    mv resources/app.asar* $out/share/${finalAttrs.pname}/

    mkdir -p $out/share/applications
    ln -s ${finalAttrs.desktopItem}/share/applications/* $out/share/applications/

    makeWrapper ${electron}/bin/electron $out/bin/${finalAttrs.pname} \
      --add-flags $out/share/${finalAttrs.pname}/app.asar

    runHook postInstall
  '';

  passthru = {
    updateScript = writeShellScript "update-stretchly" ''
      set -eu -o pipefail

      # get the latest release version
      latest_version=$(curl -s https://api.github.com/repos/hovancik/stretchly/releases/latest | jq --raw-output .tag_name | sed -e 's/^v//')

      echo "updating to $latest_version..."

      ${common-updater-scripts}/bin/update-source-version stretchly "$latest_version"
    '';
  };

  desktopItem = makeDesktopItem {
    name = finalAttrs.pname;
    exec = finalAttrs.pname;
    icon = finalAttrs.icon;
    desktopName = "Stretchly";
    genericName = "Stretchly";
    categories = [ "Utility" ];
  };

  meta = with lib; {
    description = "A break time reminder app";
    longDescription = ''
      stretchly is a cross-platform electron app that reminds you to take
      breaks when working on your computer. By default, it runs in your tray
      and displays a reminder window containing an idea for a microbreak for 20
      seconds every 10 minutes. Every 30 minutes, it displays a window
      containing an idea for a longer 5 minute break.
    '';
    homepage = "https://hovancik.net/stretchly";
    downloadPage = "https://hovancik.net/stretchly/downloads/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.linux;
    mainProgram = "stretchly";
  };
})
