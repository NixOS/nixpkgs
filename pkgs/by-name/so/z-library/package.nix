{
  lib,
  libgcc,
  atkmm,
  gtk3,
  fetchurl,
  qt5,
  dpkg,
  cups,
  autoPatchelfHook,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "z-library";
  version = "2.4.3";

  src = fetchurl {
    url = "https://s3proxy.cdn-zlib.sk/te_public_files/soft/linux/zlibrary-setup-latest.deb";
    hash = "sha256-OywGJdVUAGxK+C14akbLzhkt/5QE6+lchPHteksOLLY=";
  };

  unpackCmd = "dpkg -x $curSrc source";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    qt5.wrapQtAppsHook
  ];

  buildInputs = with qt5; [
    qtbase
    qtsvg
    qtwebengine
    cups
    libgcc
    atkmm
    gtk3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r usr/share $out
    cp -r opt $out

    substituteInPlace $out/share/applications/z-library.desktop --replace-fail 'Exec=/opt/Z-Library/z-library' 'Exec=z-library'

    ln -s $out/opt/Z-Library/z-library $out/bin/z-library

    runHook postInstall
  '';

  meta = {
    description = "Z-library desktop app";
    homepage = "https://1lib.sk/";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.Techtix0 ];
    mainProgram = "$out/bin/z-library";
  };
}
