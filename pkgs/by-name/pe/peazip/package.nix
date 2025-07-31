{
  lib,
  stdenv,
  fetchFromGitHub,
  fpc,
  lazarus,
  qt6Packages,
  writableTmpDirAsHomeHook,
  xorg,
  _7zz,
  brotli,
  runCommand,
  upx,
  zpaq,
  zstd,
}:

let
  # peazip looks for the "7z", not "7zz"
  _7z = runCommand "7z" { } ''
    mkdir -p $out/bin
    ln -s ${_7zz}/bin/7zz $out/bin/7z
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "peazip";
  version = "10.5.0";

  src = fetchFromGitHub {
    owner = "peazip";
    repo = "peazip";
    tag = finalAttrs.version;
    hash = "sha256-tEx0ZSvv+byn8OPSFprFJwMFxuEQzyrkvk4FbvGtH2A=";
  };

  sourceRoot = "${finalAttrs.src.name}/peazip-sources";

  # set it to use compression programs from $PATH
  postPatch = ''
    substituteInPlace dev/peach.pas \
      --replace-fail "  HSYSBIN       = 0;" "  HSYSBIN       = 2;"
  '';

  nativeBuildInputs = [
    fpc
    lazarus
    qt6Packages.wrapQtAppsHook
    writableTmpDirAsHomeHook # lazarus tries to create files in $HOME/.lazarus
  ];

  buildInputs = [
    xorg.libX11
  ]
  ++ (with qt6Packages; [
    libqtpas
    qtbase
  ]);

  env.NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath finalAttrs.buildInputs}";

  buildPhase = ''
    runHook preBuild

    pushd dev
    lazbuild --lazarusdir=${lazarus}/share/lazarus --add-package metadarkstyle/metadarkstyle.lpk
    lazbuild --lazarusdir=${lazarus}/share/lazarus --widgetset=qt6 --build-all project_pea.lpi
    lazbuild --lazarusdir=${lazarus}/share/lazarus --widgetset=qt6 --build-all project_peach.lpi
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D --mode 0755 dev/{pea,peazip} -t $out/lib/peazip
    mkdir -p $out/bin
    makeWrapper $out/lib/peazip/peazip $out/bin/peazip \
      ''${qtWrapperArgs[@]} \
      --prefix PATH : ${
        lib.makeBinPath [
          _7z
          brotli
          upx
          zpaq
          zstd
        ]
      }
    makeWrapper $out/lib/peazip/pea $out/bin/pea \
      ''${qtWrapperArgs[@]}

    mkdir -p $out/share/peazip $out/lib/peazip/res
    ln -s $out/share/peazip $out/lib/peazip/res/share
    cp -r res/share/{icons,lang,themes,presets} $out/share/peazip/
  ''
  # Install desktop entries
  # We don't copy res/share/batch/freedesktop_integration/additional-desktop-files/*.desktop because they are just duplicates of res/share/batch/freedesktop_integration/*.desktop
  + ''
    install -D --mode 0644 res/share/batch/freedesktop_integration/*.desktop -t $out/share/applications
    install -D --mode 0644 res/share/batch/freedesktop_integration/KDE-servicemenus/KDE6-dolphin/*.desktop -t $out/share/kio/servicemenus
    install -D --mode 0644 res/share/batch/freedesktop_integration/KDE-servicemenus/KDE5-dolphin/*.desktop -t $out/share/kservices5/ServiceMenus
    install -D --mode 0644 res/share/batch/freedesktop_integration/KDE-servicemenus/KDE4-dolphin/*.desktop -t $out/share/kde4/services/ServiceMenus
    install -D --mode 0644 res/share/batch/freedesktop_integration/KDE-servicemenus/KDE3-konqueror/*.desktop -t $out/share/apps/konqueror/servicemenus
  ''
  # Install desktop entries's icons
  + ''
    mkdir -p $out/share/icons/hicolor/256x256/apps
    ln -s $out/share/peazip/icons/peazip.png -t $out/share/icons/hicolor/256x256/apps/
    mkdir $out/share/icons/hicolor/256x256/mimetypes
    ln -s $out/share/peazip/icons/peazip_{7z,zip,cd}.png $out/share/icons/hicolor/256x256/mimetypes/
    mkdir $out/share/icons/hicolor/256x256/actions
    ln -s $out/share/peazip/icons/peazip_{add,extract,convert}.png $out/share/icons/hicolor/256x256/actions/

    runHook postInstall
  '';

  dontWrapQtApps = true;

  meta = {
    description = "File and archive manager";
    homepage = "https://peazip.github.io";
    license = lib.licenses.gpl3Only;
    longDescription = ''
      Free Zip / Unzip software and Rar file extractor. Cross-platform file and archive manager.

      Features volume spanning, compression, authenticated encryption.

      Supports 7Z, 7-Zip sfx, ACE, ARJ, Brotli, BZ2, CAB, CHM, CPIO, DEB, GZ, ISO, JAR, LHA/LZH, NSIS, OOo, PEA, RAR, RPM, split, TAR, Z, ZIP, ZIPX, Zstandard.
    '';
    mainProgram = "peazip";
    maintainers = with lib.maintainers; [ annaaurora ];
    platforms = lib.platforms.linux;
  };
})
