{ lib
, stdenv
, fetchurl
, jre
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "biglybt";
  version = "3.5.0.0";

  src = fetchurl {
    url = "https://github.com/BiglySoftware/BiglyBT/releases/download/v${version}/GitHub_BiglyBT_unix.tar.gz";
    hash = "sha256-ToTCIjunj/ABi3wVSmeddLGBdQlv+CfK2jGRjixJd0w=";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  configurePhase = ''
    runHook preConfigure

    sed -e 's/AUTOUPDATE_SCRIPT=1/AUTOUPDATE_SCRIPT=0/g' \
      -i biglybt || die

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/{share/{biglybt,applications,icons/hicolor/scalable/apps},bin}

    cp -r ./* $out/share/biglybt/

    ln -s $out/share/biglybt/biglybt.desktop $out/share/applications/

    ln -s $out/share/biglybt/biglybt.svg $out/share/icons/hicolor/scalable/apps/

    wrapProgram $out/share/biglybt/biglybt \
      --prefix PATH : ${lib.makeBinPath [ jre ]}

    ln -s $out/share/biglybt/biglybt $out/bin/
    runHook postInstall
  '';

  passthru.updateScript.command = [ ./update.sh ];

  meta = with lib; {
    description = "Feature-filled Bittorrent client based on the Azureus";
    homepage = "https://www.biglybt.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "biglybt";
  };
}
