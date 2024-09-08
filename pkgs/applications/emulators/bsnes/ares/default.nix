{ lib
, stdenv
, fetchFromGitHub
, SDL2
, alsa-lib
, gtk3
, gtksourceview3
, libGL
, libGLU
, libX11
, libXv
, libao
, libicns
, libpulseaudio
, openal
, pkg-config
, udev
, which
, wrapGAppsHook3
, darwin
, vulkan-loader
, autoPatchelfHook
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
    ./001-dont-rebuild-on-install.patch
    ./002-fix-ruby.diff
    ./003-darwin-specific.patch
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
    which
    wrapGAppsHook3
  ] ++ lib.optionals stdenv.isDarwin [
    libicns
  ];

  buildInputs = [
    SDL2
    libao
  ] ++ lib.optionals stdenv.isLinux [
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
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Cocoa
    darwin.apple_sdk_11_0.frameworks.OpenAL
  ];

  appendRunpaths = [ (lib.makeLibraryPath [ vulkan-loader ]) ];

  enableParallelBuilding = true;

  makeFlags = lib.optionals stdenv.isLinux [
    "hiro=gtk3"
  ] ++ lib.optionals stdenv.isDarwin [
    "hiro=cocoa"
    "lto=false"
    "vulkan=false"
  ] ++ [
    "local=false"
    "openmp=true"
    "prefix=$(out)"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-mmacosx-version-min=10.14";

  meta = {
    homepage = "https://ares-emu.net";
    description = "Open-source multi-system emulator with a focus on accuracy and preservation";
    mainProgram = "ares";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ Madouura AndersonTorres ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
})
# TODO: select between Qt and GTK3
