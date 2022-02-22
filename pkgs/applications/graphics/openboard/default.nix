{ mkDerivation, lib, fetchFromGitHub, copyDesktopItems, makeDesktopItem, qmake
, qtbase, qtxmlpatterns, qttools, qtwebkit, libGL, fontconfig, openssl, poppler
, ffmpeg, libva, alsa-lib, SDL, x264, libvpx, libvorbis, libtheora, libogg
, libopus, lame, fdk_aac, libass, quazip, libXext, libXfixes }:

let
  importer = mkDerivation rec {
    pname = "openboard-importer";
    version = "unstable-2016-10-08";

    src = fetchFromGitHub {
      owner = "OpenBoard-org";
      repo = "OpenBoard-Importer";
      rev = "47927bda021b4f7f1540b794825fb0d601875e79";
      sha256 = "19zhgsimy0f070caikc4vrrqyc8kv2h6rl37sy3iggks8z0g98gf";
    };

    nativeBuildInputs = [ qmake ];

    installPhase = ''
      install -Dm755 OpenBoardImporter $out/bin/OpenBoardImporter
    '';
  };
in mkDerivation rec {
  pname = "openboard";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "OpenBoard-org";
    repo = "OpenBoard";
    rev = "v${version}";
    sha256 = "sha256-OlGXGIMghil/GG6eso20+CWo/hCjarXGs6edXX9pc/M=";
  };

  postPatch = ''
    substituteInPlace OpenBoard.pro \
      --replace '/usr/include/quazip' '${quazip}/include/QuaZip-Qt5-${quazip.version}/quazip' \
      --replace '-lquazip5' '-lquazip1-qt5' \
      --replace '/usr/include/poppler' '${poppler.dev}/include/poppler'
  '';

  nativeBuildInputs = [ qmake copyDesktopItems ];

  buildInputs = [
    qtbase
    qtxmlpatterns
    qttools
    qtwebkit
    libGL
    fontconfig
    openssl
    poppler
    ffmpeg
    libva
    alsa-lib
    SDL
    x264
    libvpx
    libvorbis
    libtheora
    libogg
    libopus
    lame
    fdk_aac
    libass
    quazip
    libXext
    libXfixes
  ];

  propagatedBuildInputs = [ importer ];

  makeFlags = [ "release-install" ];

  desktopItems = [
    (makeDesktopItem {
      name = "OpenBoard";
      exec = "OpenBoard %f";
      icon = "OpenBoard";
      comment = "OpenBoard, an interactive white board application";
      desktopName = "OpenBoard";
      mimeTypes = [ "application/ubz" ];
      categories = [ "Education" ];
      startupNotify = true;
    })
  ];

  installPhase = ''
    runHook preInstall

    lrelease OpenBoard.pro

    # Replicated release_scripts/linux/package.sh
    mkdir -p $out/opt/openboard/i18n
    cp -R resources/customizations build/linux/release/product/* $out/opt/openboard/
    cp resources/i18n/*.qm $out/opt/openboard/i18n/
    install -m644 resources/linux/openboard-ubz.xml $out/opt/openboard/etc/
    install -Dm644 resources/images/OpenBoard.png $out/share/icons/hicolor/64x64/apps/OpenBoard.png

    runHook postInstall
  '';

  dontWrapQtApps = true;

  postFixup = ''
    makeWrapper $out/opt/openboard/OpenBoard $out/bin/OpenBoard \
      "''${qtWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "Interactive whiteboard application";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.linux;
  };
}
