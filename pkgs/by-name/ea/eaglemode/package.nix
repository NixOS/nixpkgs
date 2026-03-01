{
  lib,
  stdenv,
  fetchurl,
  perl,
  libx11,
  libxinerama,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  pkg-config,
  librsvg,
  glib,
  gtk3,
  libxext,
  libxxf86vm,
  poppler,
  vlc,
  ghostscript,
  makeWrapper,
  tzdata,
  makeDesktopItem,
  copyDesktopItems,
  directoryListingUpdater,
  htmldoc,
  binutils,
  gzip,
  p7zip,
  xz,
  zip,
  extraRuntimeDeps ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eaglemode";
  version = "0.96.3";

  src = fetchurl {
    url = "mirror://sourceforge/eaglemode/eaglemode-${finalAttrs.version}.tar.bz2";
    hash = "sha256-AHeupgEnyQylRWFDrPeo4b0mNONqG+6QwWnRpYknqOQ=";
  };

  # Fixes "Error: No time zones found." on the clock
  postPatch = ''
    substituteInPlace src/emClock/emTimeZonesModel.cpp \
      --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"

    substituteInPlace makers/emPdf.maker.pm \
      --replace-fail gtk+-2.0 gtk+-3.0
  '';

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    copyDesktopItems
  ];
  buildInputs = [
    perl
    libx11
    libxinerama
    libjpeg
    libpng
    libtiff
    libwebp
    librsvg
    glib
    gtk3
    libxxf86vm
    libxext
    poppler
    vlc
    ghostscript
  ];

  # The program tries to dlopen Xxf86vm, Xext and Xinerama, so we use the
  # trick on NIX_LDFLAGS and dontPatchELF to make it find them.
  buildPhase = ''
    runHook preBuild
    export NIX_LDFLAGS="$NIX_LDFLAGS -lXxf86vm -lXext -lXinerama"
    perl make.pl build
    runHook postBuild
  '';

  dontPatchELF = true;
  # eaglemode expects doc to be in the root directory
  forceShare = [
    "man"
    "info"
  ];

  installPhase =
    let
      runtimeDeps = lib.makeBinPath (
        [
          ghostscript # renders the manual
          htmldoc # renders HTML files in file browser
          perl # various display scripts use Perl

          # archive formats in the file browser:
          binutils
          gzip
          p7zip
          xz
          zip
        ]
        ++ extraRuntimeDeps
      );
    in
    ''
      runHook preInstall
      perl make.pl install dir=$out
      wrapProgram $out/bin/eaglemode --set EM_DIR "$out" --prefix LD_LIBRARY_PATH : "$out/lib" --prefix PATH : "${runtimeDeps}"
      for i in 32 48 96; do
        mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
        ln -s $out/res/icons/eaglemode$i.png $out/share/icons/hicolor/''${i}x''${i}/apps/eaglemode.png
      done
      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "eaglemode";
      exec = "eaglemode";
      icon = "eaglemode";
      desktopName = "Eagle Mode";
      genericName = "Zoomable User Interface";
      categories = [
        "Game"
        "Graphics"
        "System"
        "Utility"
      ];
    })
  ];

  passthru.updateScript = directoryListingUpdater {
    url = "https://eaglemode.sourceforge.net/download.html";
    extraRegex = "(?!.*(x86_64|setup64|livecd|amd64)).*";
  };

  meta = {
    homepage = "https://eaglemode.sourceforge.net";
    description = "Zoomable User Interface";
    changelog = "https://eaglemode.sourceforge.net/ChangeLog.html";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      chuangzhu
    ];
    platforms = lib.platforms.linux;
  };
})
