{ stdenv, lib, fetchurl, makeWrapper, wrapGAppsHook, electron
, common-updater-scripts
, writeShellScript
}:

stdenv.mkDerivation rec {
  pname = "stretchly";
  version = "0.21.1";

  src = fetchurl {
    url = "https://github.com/hovancik/stretchly/releases/download/v${version}/stretchly-${version}.tar.xz";
    sha256 = "0776pywyqylwd33m85l4wdr89x0q9xkrjgliag10fp1bswz844lf";
  };

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname}/
    mv resources/app.asar $out/share/${pname}/

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/app.asar \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"

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

  meta = with stdenv.lib; {
    description = "A break time reminder app";
    longDescription = ''
      stretchly is a cross-platform electron app that reminds you to take
      breaks when working on your computer. By default, it runs in your tray
      and displays a reminder window containing an idea for a microbreak for 20
      seconds every 10 minutes. Every 30 minutes, it displays a window
      containing an idea for a longer 5 minute break.
    '';
    homepage = https://hovancik.net/stretchly;
    downloadPage = https://hovancik.net/stretchly/downloads/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ cdepillabout ];
    platforms = platforms.linux;
  };
}
