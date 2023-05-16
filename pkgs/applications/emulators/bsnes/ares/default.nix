{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
=======
, pkg-config
, which
, wrapGAppsHook
, libicns
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, SDL2
, alsa-lib
, gtk3
, gtksourceview3
, libGL
, libGLU
, libX11
, libXv
, libao
<<<<<<< HEAD
, libicns
, libpulseaudio
, openal
, pkg-config
, udev
, which
, wrapGAppsHook
, darwin
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ares";
  version = "133";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ares-emulator";
    repo = "ares";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-KCpHiIdid5h5CU2uyMOo+p5h50h3Ki5/4mUpdTAPKQA=";
  };

  patches = [
    ./001-dont-rebuild-on-install.patch
    ./002-fix-ruby.diff
    ./003-darwin-specific.patch
=======
    hash = "sha256-gex53bh/175/i0cMimcPO26C6cxqQGPo4sp2bxh1sAw=";
  };

  patches = [
    ./000-dont-rebuild-on-install.patch
    ./001-fix-ruby.patch
    ./002-sips-to-png2icns.patch
    ./003-fix-darwin-install.patch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    darwin.apple_sdk_11_0.frameworks.Cocoa
    darwin.apple_sdk_11_0.frameworks.OpenAL
=======
    Cocoa
    OpenAL
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    "-C desktop-ui"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-mmacosx-version-min=10.14";

<<<<<<< HEAD
  meta = {
    homepage = "https://ares-emu.net";
    description = "Open-source multi-system emulator with a focus on accuracy and preservation";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ Madouura AndersonTorres ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
})
# TODO: select between Qt and GTK3
=======
  meta = with lib; {
    homepage = "https://ares-emu.net";
    description = "Open-source multi-system emulator with a focus on accuracy and preservation";
    license = licenses.isc;
    maintainers = with maintainers; [ Madouura AndersonTorres ];
    platforms = platforms.unix;
  };
})
# TODO: select between Qt, GTK2 and GTK3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
