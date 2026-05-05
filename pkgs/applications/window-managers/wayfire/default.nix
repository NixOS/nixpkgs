{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  cmake,
  meson,
  ninja,
  pkg-config,
  wf-config,
  cairo,
  doctest,
  libGL,
  libdrm,
  libexecinfo,
  libevdev,
  libinput,
  libjpeg,
  libxkbcommon,
  libxml2,
  vulkan-headers,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots_0_20,
  pango,
  libxcb-wm,
  yyjson,
}:
let
  wlroots = wlroots_0_20;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire";
  version = "0.11.0-unstable-2026-04-17";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire";
    rev = "9a568ffd7a2af8780926da50f89908ec4f38bf3a";
    fetchSubmodules = true;
    hash = "sha256-sIwBNBY0qN+4+a9KAS8WDGCNyrX5O0tKPPIT8ebLRqo=";
  };

  postPatch = ''
    substituteInPlace plugins/common/wayfire/plugins/common/cairo-util.hpp \
      --replace "<drm_fourcc.h>" "<libdrm/drm_fourcc.h>"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libGL
    libdrm
    libexecinfo
    libevdev
    libinput
    libjpeg
    libxml2
    vulkan-headers
    libxcb-wm
  ];

  propagatedBuildInputs = [
    wf-config
    wlroots
    wayland
    cairo
    pango
    yyjson
    libxkbcommon
    wayland-protocols
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

  passthru.tests.mate = nixosTests.mate-wayland;

  meta = {
    homepage = "https://wayfire.org/";
    description = "3D Wayland compositor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      teatwig
      wucke13
      wineee
    ];
    platforms = lib.platforms.unix;
    mainProgram = "wayfire";
  };
})
