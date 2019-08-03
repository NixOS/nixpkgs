{ stdenv, fetchurl, makeDesktopItem, makeWrapper, appimage-run }:

stdenv.mkDerivation rec {
  pname = "ledger-live-desktop";
  version = "1.12.0";

  src = fetchurl {
    url = "https://github.com/LedgerHQ/${pname}/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
    sha256 = "0sn0ri8kqvy36d6vjwsb0mh54nwic58416m6q5drl1schsn6wyvj";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ appimage-run ];

  desktopIcon = fetchurl {
    url = "https://raw.githubusercontent.com/LedgerHQ/${pname}/v${version}/build/icon.png";
    sha256 = "1mmfaf0yk7xf1kgbs3ka8wsbz1qgh60xj6z91ica1i7lw2qbdd5h";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "${placeholder "out"}/bin/${pname}";
    icon = pname;
    desktopName = "Ledger Live";
    categories = "Utility;";
  };

  unpackPhase = ":";

  installPhase = ''
    runHook preInstall

    ${desktopItem.buildCommand}
    install -D $src $out/share/${src.name}
    install -Dm -x ${desktopIcon} \
      $out/share/icons/hicolor/1024x1024/apps/${pname}.png
    makeWrapper ${appimage-run}/bin/appimage-run $out/bin/${pname} \
      --add-flags $out/share/${src.name}

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Wallet app for Ledger Nano S and Ledger Blue";
    homepage = "https://www.ledger.com/live";
    license = licenses.mit;
    maintainers = with maintainers; [ thedavidmeister ];
    platforms = [ "x86_64-linux" ];
  };
}
