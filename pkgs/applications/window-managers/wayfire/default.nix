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

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Z+rR9pY244I3i/++XZ4ROIkq3vtzMgcxxHvJNxFD9is=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

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

  meta = {
    homepage = "https://wayfire.org/";
    description = "3D Wayland compositor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qyliss wucke13 rewine ];
    platforms = lib.platforms.unix;
    mainProgram = "wayfire";
  };
})
