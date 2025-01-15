{
  lib,
  SDL2,
  alsa-lib,
  autoPatchelfHook,
  fetchFromGitHub,
  gtk3,
  gtksourceview3,
  libGL,
  libGLU,
  libX11,
  libXv,
  libao,
  libicns,
  libpulseaudio,
  librashader,
  openal,
  pkg-config,
  stdenv,
  udev,
  vulkan-loader,
  which,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ares";
  version = "141";

  src = fetchFromGitHub {
    owner = "ares-emulator";
    repo = "ares";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iNcoNdGw/DfYc9tsOGsPYoZLhVwNzJe8bVotx6Rl0j4=";
  };

  patches = [
    ./patches/001-dont-rebuild-on-install.patch
  ];

  nativeBuildInputs =
    [
      autoPatchelfHook
      pkg-config
      which
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libicns
    ];

  buildInputs =
    [
      SDL2
      libao
      librashader
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      gtk3
      gtksourceview3
      libGL
      libGLU
      libX11
      libXv
      libpulseaudio
      openal
      udev
    ];

  appendRunpaths = [
    (lib.makeLibraryPath [
      librashader
      vulkan-loader
    ])
  ];

  makeFlags =
    lib.optionals stdenv.hostPlatform.isLinux [
      "hiro=gtk3"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "hiro=cocoa"
      "lto=false"
      "vulkan=false"
    ]
    ++ [
      "local=false"
      "openmp=true"
      "prefix=$(out)"
    ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-mmacosx-version-min=10.14";

  meta = {
    homepage = "https://ares-emu.net";
    description = "Open-source multi-system emulator with a focus on accuracy and preservation";
    license = lib.licenses.isc;
    mainProgram = "ares";
    maintainers = with lib.maintainers; [
      Madouura
      AndersonTorres
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
# TODO: select between Qt and GTK3
# TODO: call Darwin hackers to deal with specific errors
