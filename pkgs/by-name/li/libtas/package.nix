{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  autoreconfHook,
  pkg-config,
  SDL2,
  alsa-lib,
  ffmpeg,
  lua5_4,
  qt5,
  libxi,
  file,
  binutils,
  makeDesktopItem,

  # Forces libTAS to run in X11.
  # Enabled by default because libTAS does not support Wayland.
  withForceX11 ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtas";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "clementgallet";
    repo = "libTAS";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TDFpLleY7+uBjcIqF9e7mA5eQN2s+U04qVQRvpfFfcQ=";
  };
  patches = [
    # Fix build with gcc15
    (fetchpatch2 {
      url = "https://github.com/clementgallet/libTAS/commit/9699b158c522cf778bcdf626d0520fdd0a8b83aa.patch?full_index=1";
      hash = "sha256-vM1f6rvKIFyzEGJ7k+b/Zp4gAv8u6mdDUD5evV+hCJU=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    qt5.wrapQtAppsHook
    pkg-config
  ];
  buildInputs = [
    SDL2
    alsa-lib
    ffmpeg
    lua5_4
    qt5.qtbase
  ];

  configureFlags = [
    "--enable-release-build"
  ];

  postInstall = ''
    mkdir -p $out/lib
    mv $out/bin/libtas*.so $out/lib/
  '';

  enableParallelBuilding = true;

  postFixup = ''
    wrapProgram $out/bin/libTAS \
      --suffix PATH : ${
        lib.makeBinPath [
          file
          binutils
          ffmpeg
        ]
      } \
      --suffix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libxi
          ffmpeg.lib
        ]
      } \
      ${lib.optionalString withForceX11 "--set QT_QPA_PLATFORM xcb"} \
      --set-default LIBTAS_SO_PATH $out/lib/libtas.so
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "libTAS";
      desktopName = "libTAS";
      exec = "libTAS %U";
      icon = "libTAS";
      startupWMClass = "libTAS";
      keywords = [ "libTAS" ];
    })
  ];

  meta = {
    homepage = "https://clementgallet.github.io/libTAS/";
    changelog = "https://github.com/clementgallet/libTAS/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "GNU/Linux software to give TAS tools to games";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ skyrina ];
    mainProgram = "libTAS";
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
