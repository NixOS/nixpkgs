{
  stdenv,
  lib,
  fetchFromGitHub,
  libsForQt5,
  fpc,
  lazarus,
  xorg,
  libqt5pas,
  runCommand,
  _7zz,
  archiver,
  brotli,
  upx,
  zpaq,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "peazip";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "peazip";
    repo = pname;
    rev = version;
    hash = "sha256-dxFGYMq1L7oRGUAfshLTBCXrYL6lzJPu5qIItrjeE5c=";
  };
  sourceRoot = "${src.name}/peazip-sources";

  postPatch = ''
    # set it to use compression programs from $PATH
    substituteInPlace dev/peach.pas --replace "  HSYSBIN       = 0;" "  HSYSBIN       = 2;"
  '';

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    lazarus
    fpc
  ];

  buildInputs = [
    xorg.libX11
    libqt5pas
  ];

  NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath buildInputs}";

  buildPhase = ''
    # lazarus tries to create files in $HOME/.lazarus
    export HOME=$(mktemp -d)
    pushd dev
    lazbuild --lazarusdir=${lazarus}/share/lazarus --add-package metadarkstyle/metadarkstyle.lpk
    lazbuild --lazarusdir=${lazarus}/share/lazarus --widgetset=qt5 --build-all project_pea.lpi
    lazbuild --lazarusdir=${lazarus}/share/lazarus --widgetset=qt5 --build-all project_peach.lpi
    popd
  '';

  # peazip looks for the "7z", not "7zz"
  _7z = runCommand "7z" { } ''
    mkdir -p $out/bin
    ln -s ${_7zz}/bin/7zz $out/bin/7z
  '';

  installPhase = ''
    runHook preInstall

    install -D dev/{pea,peazip} -t $out/lib/peazip
    wrapProgram $out/lib/peazip/peazip --prefix PATH : ${
      lib.makeBinPath [
        _7z
        archiver
        brotli
        upx
        zpaq
        zstd
      ]
    }
    mkdir -p $out/bin
    ln -s $out/lib/peazip/{pea,peazip} $out/bin/

    mkdir -p $out/share/peazip $out/lib/peazip/res/share
    ln -s $out/share/peazip $out/lib/peazip/res/share
    cp -r res/share/{icons,lang,themes,presets} $out/share/peazip/
    # Install desktop entries
    install -D res/share/batch/freedesktop_integration/*.desktop -t $out/share/applications
    # Install desktop entries's icons
    mkdir -p $out/share/icons/hicolor/256x256/apps
    ln -s $out/share/peazip/icons/peazip.png -t $out/share/icons/hicolor/256x256/apps/
    mkdir $out/share/icons/hicolor/256x256/mimetypes
    ln -s $out/share/peazip/icons/peazip_{7z,zip,cd}.png $out/share/icons/hicolor/256x256/mimetypes/
    mkdir $out/share/icons/hicolor/256x256/actions
    ln -s $out/share/peazip/icons/peazip_{add,extract,convert}.png $out/share/icons/hicolor/256x256/actions/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cross-platform file and archive manager";
    longDescription = ''
      Free Zip / Unzip software and Rar file extractor. Cross-platform file and archive manager.

      Features volume spanning, compression, authenticated encryption.

      Supports 7Z, 7-Zip sfx, ACE, ARJ, Brotli, BZ2, CAB, CHM, CPIO, DEB, GZ, ISO, JAR, LHA/LZH, NSIS, OOo, PEA, RAR, RPM, split, TAR, Z, ZIP, ZIPX, Zstandard.
    '';
    license = licenses.gpl3Only;
    homepage = "https://peazip.github.io";
    platforms = platforms.linux;
    maintainers = with maintainers; [ annaaurora ];
    mainProgram = "peazip";
  };
}
