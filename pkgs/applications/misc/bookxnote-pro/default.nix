{ lib
, stdenv
, fetchurl

, autoPatchelfHook
, dpkg
, wrapQtAppsHook
, makeDesktopItem
, copyDesktopItems

, qtmultimedia
, qtspeech
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bookxnote-pro";
  version = "2.0.0.1112";

  src = fetchurl {
    url = "http://www.bookxnote.com/setup/BookxNotePro_ubuntu_amd64-${finalAttrs.version}.deb";
    hash = "sha256-ZIRxoGvQHXOw0FNzvLB/t+bsRXi5qz9BIt0ioXcNOnk=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    dpkg
    wrapQtAppsHook
  ];

  buildInputs = [
    qtmultimedia
    qtspeech
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "BookxNotePro";
      exec = "BookxNotePro %u";
      icon = "bxn_pro_logo";
      comment = finalAttrs.meta.description;
      desktopName = "BookxNotePro";
    })
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/app $out/bin

    pushd usr/local/BookxNotePro
    cp -r emojis lang theme BookxNotePro $out/app
    install -Dm644 bxn_pro_logo.png $out/share/icons/hicolor/512x512/apps/bxn_pro_logo.png
    popd

    ln -s $out/app/BookxNotePro $out/bin/BookxNotePro

    runHook postInstall
  '';

  meta = {
    description = "A book reader for Linux, an alternative to Marginnote on macOS";
    homepage = "http://www.bookxnote.com";
    license = lib.licenses.unfree;
    mainProgram = "BookxNotePro";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = [ "x86_64-linux" ];
  };
})
