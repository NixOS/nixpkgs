{ lib
, stdenv
, fetchFromGitHub
, cmake
, meson
, ninja
, pkg-config
, wf-config
, cairo
, doctest
, libdrm
, libexecinfo
, libinput
, libjpeg
, libxkbcommon
, wayland
, wayland-protocols
, wayland-scanner
, wlroots
, pango
, xorg
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "wayfire";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "WayfireWM";
<<<<<<< HEAD
    repo = "wayfire";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Z+rR9pY244I3i/++XZ4ROIkq3vtzMgcxxHvJNxFD9is=";
=======
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-Z+rR9pY244I3i/++XZ4ROIkq3vtzMgcxxHvJNxFD9is=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    wf-config
    libdrm
    libexecinfo
    libinput
    libjpeg
    libxkbcommon
    wayland-protocols
    xorg.xcbutilwm
    wayland
    cairo
    pango
  ];

  propagatedBuildInputs = [
    wlroots
  ];

  nativeCheckInputs = [
    cmake
    doctest
  ];

  # CMake is just used for finding doctest.
  dontUseCmakeConfigure = true;

  doCheck = true;

  mesonFlags = [
    "--sysconfdir /etc"
    "-Duse_system_wlroots=enabled"
    "-Duse_system_wfconfig=enabled"
    (lib.mesonEnable "wf-touch:tests" (stdenv.buildPlatform.canExecute stdenv.hostPlatform))
  ];

  passthru.providedSessions = [ "wayfire" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://wayfire.org/";
    description = "3D Wayland compositor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qyliss wucke13 rewine ];
    platforms = lib.platforms.unix;
    mainProgram = "wayfire";
  };
})
=======
  meta = with lib; {
    homepage = "https://wayfire.org/";
    description = "3D Wayland compositor";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 rewine ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
