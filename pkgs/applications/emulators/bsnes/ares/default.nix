{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, which
, wrapGAppsHook
, libicns
, SDL2
, alsa-lib
, gtk3
, gtksourceview3
, libGL
, libGLU
, libX11
, libXv
, libao
, libpulseaudio
, openal
, udev
, darwin
}:

let
  inherit (darwin.apple_sdk_11_0.frameworks) Cocoa OpenAL;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ares";
  version = "131";

  src = fetchFromGitHub {
    owner = "ares-emulator";
    repo = "ares";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gex53bh/175/i0cMimcPO26C6cxqQGPo4sp2bxh1sAw=";
  };

  patches = [
    ./000-dont-rebuild-on-install.patch
    ./001-fix-ruby.patch
    ./002-sips-to-png2icns.patch
    ./003-fix-darwin-install.patch
  ];

  nativeBuildInputs = [
    pkg-config
    which
    wrapGAppsHook
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
    Cocoa
    OpenAL
  ];

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
    "-C desktop-ui"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-mmacosx-version-min=10.14";

  meta = with lib; {
    homepage = "https://ares-emu.net";
    description = "Open-source multi-system emulator with a focus on accuracy and preservation";
    license = licenses.isc;
    maintainers = with maintainers; [ Madouura AndersonTorres ];
    platforms = platforms.unix;
  };
})
# TODO: select between Qt, GTK2 and GTK3
