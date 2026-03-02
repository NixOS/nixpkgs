{
  lib,
  stdenv,
  fetchurl,

  dpkg,
  autoPatchelfHook,
  makeWrapper,

  atk,
  coreutils,
  glib,
  gnugrep,
  libayatana-appindicator,
  libusb1,
  mpv,
}:
stdenv.mkDerivation rec {
  pname = "polymath";
  version = "1.4.0.7";

  src = fetchurl {
    url = "https://fluxkeyboard.com/updates/polymath/linux/deb/polymath_${version}_amd64.deb";
    hash = "sha256-EYLBTd9r0s3Bxm4Gy8wbCNS0dyuXLI1jt6raSzrP/00=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [
    atk
    glib
    libayatana-appindicator
    libusb1
    mpv
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv usr/* $out/
    rmdir usr
    mv ./* $out/

    # Move Pixmaps to icons folder
    mkdir -p $out/share/icons/hicolor/512x512/apps
    mv $out/share/pixmaps/polymath.png $out/share/icons/hicolor/512x512/apps/
    rmdir $out/share/pixmaps

    # patch launch binary
    makeWrapper $out/opt/polymath/polymath $out/bin/polymath \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            gnugrep
          ]
        }

    # Fix Paths in Desktop file
    sed -i -e "s|Exec=.*|Exec=$out/bin/polymath|g" $out/share/applications/polymath.desktop
    sed -i -e "s|Icon=.*|Icon=polymath|g" $out/share/applications/polymath.desktop

    runHook postInstall
  '';

  meta = {
    description = "Flux Keyboard Software: Polymath";
    homepage = "https://fluxkeyboard.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      darkjaguar91
      michailik
    ];
    platforms = [ "x86_64-linux" ];
  };
}
