{
  lib,
  stdenv,
  fetchurl,
  jre,
  wrapGAppsHook,
  nix-update-script,
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(v[0-9.]+)$"
    ];
  };

  meta = {
    changelog = "https://github.com/BiglySoftware/BiglyBT/releases/tag/v${version}";
    description = "A BitTorrent client based on the Azureus that supports I2P darknet for privacy";
    downloadPage = "https://github.com/BiglySoftware/BiglyBT";
    homepage = "https://www.biglybt.com/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "biglybt";
    maintainers = with lib.maintainers; [ raspher ];
  };
}
