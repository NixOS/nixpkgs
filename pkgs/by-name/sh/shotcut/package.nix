{
  lib,
  fetchFromGitHub,
  stdenv,
  replaceVars,
  SDL2,
  frei0r,
  opencv4,
  ladspaPlugins,
  gettext,
  jack1,
  pkg-config,
  fftw,
  qt6,
  qt6Packages,
  cmake,
  gitUpdater,
  ffmpeg_8,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shotcut";
  version = "26.7.30";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "shotcut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZfJ4ADJBCriC67YpRiKbJKW799iJnXcS1dp7AQoz2Ew=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    qt6.wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs = [
    SDL2
    (frei0r.override { opencv = opencv4.override { ffmpeg_8-headless = ffmpeg_8; }; })
    ladspaPlugins
    gettext
    qt6Packages.mlt
    fftw
    qt6.qtbase
    qt6.qttools
    qt6.qtmultimedia
    qt6.qtcharts
    qt6.qtwebsockets
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6.qtwayland
  ];

  env.NIX_CFLAGS_COMPILE = "-DSHOTCUT_NOUPGRADE";

  cmakeFlags = [ "-DSHOTCUT_VERSION=${finalAttrs.version}" ];

  patches = [
    (replaceVars ./fix-mlt-ffmpeg-path.patch {
      ffmpeg = ffmpeg_8;
      mlt = qt6Packages.mlt;
    })
  ];

  dontWrapGApps = true;

  qtWrapperArgs = [
    "--set FREI0R_PATH ${
      (frei0r.override { opencv = opencv4.override { ffmpeg_8-headless = ffmpeg_8; }; })
    }/lib/frei0r-1"
    "--set LADSPA_PATH ${ladspaPlugins}/lib/ladspa"
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath ([ SDL2 ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ jack1 ])
    }"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications $out/bin
    mv $out/Shotcut.app $out/Applications/Shotcut.app
    ln -s $out/Applications/Shotcut.app/Contents/MacOS/Shotcut $out/bin/shotcut
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Free, open source, cross-platform video editor";
    longDescription = ''
      An official binary for Shotcut, which includes all the
      dependencies pinned to specific versions, is provided on
      http://shotcut.org.

      If you encounter problems with this version, please contact the
      nixpkgs maintainer(s). If you wish to report any bugs upstream,
      please use the official build from shotcut.org instead.
    '';
    homepage = "https://shotcut.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      woffs
      peti
      nick-linux
    ];
    platforms = lib.platforms.unix;
    mainProgram = "shotcut";
  };
})
