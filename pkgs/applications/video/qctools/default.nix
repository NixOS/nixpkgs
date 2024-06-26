{
  lib,
  stdenv,
  fetchurl,
  qmake,
  wrapQtAppsHook,
  ffmpeg,
  qtmultimedia,
  qwt,
}:

stdenv.mkDerivation rec {
  pname = "qctools";
  version = "1.3.1";

  src = fetchurl {
    url = "https://mediaarea.net/download/source/${pname}/${version}/${pname}_${version}.tar.xz";
    hash = "sha256-ClF8KiVjV2JTCjz/ueioojhiHZf8UW9WONaJrIx4Npo=";
  };

  sourceRoot = "${pname}/Project/QtCreator";

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    ffmpeg
    qtmultimedia
    qwt
  ];

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin qctools-cli/qcli qctools-gui/QCTools
    cd ../GNU/GUI
    install -Dm644 qctools.desktop $out/share/applications/qctools.desktop
    install -Dm644 qctools.metainfo.xml $out/share/metainfo/qctools.metainfo.xml
    cd ../../../Source/Resource
    install -Dm 0644 Logo.png $out/share/icons/hicolor/256x256/apps/qctools.png
    install -Dm 0644 Logo.png $out/share/pixmaps/qctools.png
    cd ../../Project/QtCreator

    runHook postInstall
  '';

  meta = with lib; {
    description = "Audiovisual analytics and filtering of video files";
    homepage = "https://mediaarea.net/QCTools";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
