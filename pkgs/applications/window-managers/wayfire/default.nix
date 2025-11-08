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
  xorg,
  yyjson,
}:
let
  wlroots = wlroots_0_19;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire";
  version = "0.10.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-rnrcuikfRPnIfIkmKUIRh8Sm+POwFLzaZZMAlmeBdjY=";
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
    libxkbcommon
    libxml2
    vulkan-headers
    wayland-protocols
    xorg.xcbutilwm
    yyjson
  ];

  propagatedBuildInputs = [
    wf-config
    wlroots
    wayland
    cairo
    pango
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
