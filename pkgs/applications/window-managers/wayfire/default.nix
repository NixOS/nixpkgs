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
  wlroots_0_19,
  pango,
  libxcb-wm,
  yyjson,
}:
let
  wlroots = wlroots_0_19;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire";
  version = "0.11.0-unstable-2026-02-20";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire";
    rev = "ad2c781a4c76b7539fa86e39fd3ef07ea3465070";
    fetchSubmodules = true;
    hash = "sha256-NADPszDx4D/1SlCvkS4IQaTP7O0+6FVzKWitxyBzyLA=";
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
