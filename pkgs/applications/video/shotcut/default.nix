{
  lib,
  fetchFromGitHub,
  stdenv,
  wrapQtAppsHook,
  substituteAll,
  SDL2,
  frei0r,
  ladspaPlugins,
  gettext,
  mlt,
  jack1,
  pkg-config,
  fftw,
  qtbase,
  qttools,
  qtmultimedia,
  qtcharts,
  cmake,
  Cocoa,
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "shotcut";
  version = "24.04.28";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "shotcut";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iMg2XrTrLFZXXvnJ7lMdkxf/LTaL9bh9Nc2jsPOS0eo=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    wrapQtAppsHook
  ];
  buildInputs =
    [
      SDL2
      frei0r
      ladspaPlugins
      gettext
      mlt
      fftw
      qtbase
      qttools
      qtmultimedia
      qtcharts
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Cocoa
    ];

  env.NIX_CFLAGS_COMPILE = "-DSHOTCUT_NOUPGRADE";
  cmakeFlags = [
    "-DSHOTCUT_VERSION=${finalAttrs.version}"
  ];

  patches = [
    (substituteAll {
      inherit mlt;
      src = ./fix-mlt-ffmpeg-path.patch;
    })
  ];

  qtWrapperArgs = [
    "--set FREI0R_PATH ${frei0r}/lib/frei0r-1"
    "--set LADSPA_PATH ${ladspaPlugins}/lib/ladspa"
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath ([ SDL2 ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ jack1 ])
    }"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications $out/bin
    mv $out/Shotcut.app $out/Applications/Shotcut.app
    ln -s $out/Applications/Shotcut.app/Contents/MacOS/Shotcut $out/bin/shotcut
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "A free, open source, cross-platform video editor";
    longDescription = ''
      An official binary for Shotcut, which includes all the
      dependencies pinned to specific versions, is provided on
      http://shotcut.org.

      If you encounter problems with this version, please contact the
      nixpkgs maintainer(s). If you wish to report any bugs upstream,
      please use the official build from shotcut.org instead.
    '';
    homepage = "https://shotcut.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      goibhniu
      woffs
      peti
    ];
    platforms = platforms.unix;
    mainProgram = "shotcut";
  };
})
