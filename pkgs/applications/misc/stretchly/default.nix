{ stdenv
, lib
, fetchurl
, makeWrapper
, electron
, common-updater-scripts
, writeShellScript
, makeDesktopItem
}:

stdenv.mkDerivation rec {

  pname = "stretchly";
  version = "1.8.1";

  src = fetchurl {
    url = "https://github.com/hovancik/stretchly/releases/download/v${version}/stretchly-${version}.tar.xz";
    sha256 = "sha256-/v74vDGxD5iiOPeBXPAaV42JpyBjeJSO/Lk88pCkDng=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/hovancik/stretchly/v${version}/stretchly_128x128.png";
    sha256 = "0whfg1fy2hjyk1lzpryikc1aj8agsjhfrb0bf7ggl6r9m8s1rvdl";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname}/
    mv resources/app.asar* $out/share/${pname}/

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/app.asar

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
    name = pname;
    exec = pname;
    icon = icon;
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
    maintainers = with maintainers; [ _1000101 oxalica ];
    platforms = platforms.linux;
  };
}
