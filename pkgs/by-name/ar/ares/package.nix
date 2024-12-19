{
  lib,
  SDL2,
  alsa-lib,
  apple-sdk_11,
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
  version = "136";

  src = fetchFromGitHub {
    owner = "ares-emulator";
    repo = "ares";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Hks/MWusPiBVdb5L+53qtR6VmXG/P4rDzsvHxLeA8Do=";
  };

  patches = [
    ./patches/001-dont-rebuild-on-install.patch
    ./patches/002-fix-ruby.diff
    ./patches/003-darwin-specific.patch
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
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
    ];

  appendRunpaths = [ (lib.makeLibraryPath [ vulkan-loader ]) ];

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
