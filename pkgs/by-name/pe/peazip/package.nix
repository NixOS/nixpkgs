{
  stdenv,
  lib,
  fetchFromGitHub,
  qt6Packages,
  fpc,
  lazarus,
  xorg,
  runCommand,
  _7zz,
  brotli,
  upx,
  zpaq,
  zstd,
  writableTmpDirAsHomeHook,
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
  version = "10.6.1";

  src = fetchFromGitHub {
    owner = "peazip";
    repo = "peazip";
    rev = finalAttrs.version;
    hash = "sha256-y+q4S3XHkN2dvHMaRxPQwK9l9LaA5rGvrzzZ+x76qUQ=";
  };
  sourceRoot = "${finalAttrs.src.name}/peazip-sources";

  postPatch = ''
    # set it to use compression programs from $PATH
    substituteInPlace dev/peach.pas --replace-fail "  HSYSBIN       = 0;" "  HSYSBIN       = 2;"
  '';

  nativeBuildInputs = [
    qt6Packages.wrapQtAppsHook
    lazarus
    fpc
    # lazarus tries to create files in $HOME/.lazarus
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    xorg.libX11
  ]
  ++ (with qt6Packages; [
    qtbase
    libqtpas
  ]);

  env.NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath finalAttrs.buildInputs}";

  buildPhase = ''
    pushd dev
    lazbuild --lazarusdir=${lazarus}/share/lazarus --add-package metadarkstyle/metadarkstyle.lpk
    lazbuild --lazarusdir=${lazarus}/share/lazarus --widgetset=qt6 --build-all project_pea.lpi
    lazbuild --lazarusdir=${lazarus}/share/lazarus --widgetset=qt6 --build-all project_peach.lpi
    popd
  '';

  installPhase = ''
    runHook preInstall

    install -D dev/{pea,peazip} -t $out/lib/peazip
    mkdir -p $out/bin
    makeWrapper $out/lib/peazip/peazip $out/bin/peazip \
      --prefix PATH : ${
        lib.makeBinPath [
          _7z
          brotli
          upx
          zpaq
          zstd
        ]
      } \
      ''${qtWrapperArgs[@]} # putting this here as to not have double wrapping
    makeWrapper $out/lib/peazip/pea $out/bin/pea \
      ''${qtWrapperArgs[@]} # putting this here as to not have double wrapping

    mkdir -p $out/share/peazip $out/lib/peazip/res
    ln -s $out/share/peazip $out/lib/peazip/res/share
    cp -r res/share/{icons,lang,themes,presets} $out/share/peazip/
    # Install desktop entries
    # We don't copy res/share/batch/freedesktop_integration/additional-desktop-files/*.desktop because they are just duplicates of res/share/batch/freedesktop_integration/*.desktop
    install -D res/share/batch/freedesktop_integration/*.desktop -t $out/share/applications
    install -D res/share/batch/freedesktop_integration/KDE-servicemenus/KDE6-dolphin/*.desktop -t $out/share/kio/servicemenus
    install -D res/share/batch/freedesktop_integration/KDE-servicemenus/KDE5-dolphin/*.desktop -t $out/share/kservices5/ServiceMenus
    install -D res/share/batch/freedesktop_integration/KDE-servicemenus/KDE4-dolphin/*.desktop -t $out/share/kde4/services/ServiceMenus
    install -D res/share/batch/freedesktop_integration/KDE-servicemenus/KDE3-konqueror/*.desktop -t $out/share/apps/konqueror/servicemenus

    # Install desktop entries's icons
    for size in {48,256}; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      mkdir $out/share/icons/hicolor/"$size"x"$size"/mimetypes
      mkdir $out/share/icons/hicolor/"$size"x"$size"/actions
    done

    pushd res/share/batch/freedesktop_integration

    cp peazip.png $out/share/icons/hicolor/256x256/apps/
    pushd additional-desktop-files
    cp peazip_{7z,cd,zip}.png $out/share/icons/hicolor/256x256/mimetypes/
    cp peazip_{add,extract,convert}.png $out/share/icons/hicolor/256x256/actions/
    popd

    pushd alternative-icons/48px
    # for some reason the maintainer only made 48px version of *some* icons
    cp peazip.png $out/share/icons/hicolor/48x48/apps/
    cp peazip_{add,extract}.png $out/share/icons/hicolor/48x48/actions/
    popd

    popd

    runHook postInstall
  '';

  dontWrapQtApps = true;

  meta = {
    description = "File and archive manager";
    longDescription = ''
      Free Zip / Unzip software and Rar file extractor. File and archive manager.

      Features volume spanning, compression, authenticated encryption.

      Supports 7Z, 7-Zip sfx, ACE, ARJ, Brotli, BZ2, CAB, CHM, CPIO, DEB, GZ, ISO, JAR, LHA/LZH, NSIS, OOo, PEA, RAR, RPM, split, TAR, Z, ZIP, ZIPX, Zstandard.
    '';
    license = lib.licenses.gpl3Only;
    homepage = "https://peazip.github.io";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ annaaurora ];
    mainProgram = "peazip";
  };
})
