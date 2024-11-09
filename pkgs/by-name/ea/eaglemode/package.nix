{
  lib,
  stdenv,
  fetchurl,
  perl,
  libX11,
  libXinerama,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  pkg-config,
  librsvg,
  glib,
  gtk2,
  libXext,
  libXxf86vm,
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

stdenv.mkDerivation rec {
  pname = "eaglemode";
  version = "0.96.2";

  src = fetchurl {
    url = "mirror://sourceforge/eaglemode/${pname}-${version}.tar.bz2";
    hash = "sha256:1al5n2mcjp0hmsvi4hsdmzd7i0id5i3255xplk0il1nmzydh312a";
  };

  # Fixes "Error: No time zones found." on the clock
  postPatch = ''
    substituteInPlace src/emClock/emTimeZonesModel.cpp --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    copyDesktopItems
  ];
  buildInputs = [
    perl
    libX11
    libXinerama
    libjpeg
    libpng
    libtiff
    libwebp
    librsvg
    glib
    gtk2
    libXxf86vm
    libXext
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
        ln -s $out/res/icons/${pname}$i.png $out/share/icons/hicolor/''${i}x''${i}/apps/${pname}.png
      done
      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "Eagle Mode";
      genericName = meta.description;
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
    extraRegex = "(?!.*(x86_64|setup64|livecd)).*";
  };

  meta = with lib; {
    homepage = "https://eaglemode.sourceforge.net";
    description = "Zoomable User Interface";
    changelog = "https://eaglemode.sourceforge.net/ChangeLog.html";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      chuangzhu
      ehmry
    ];
    platforms = platforms.linux;
  };
}
