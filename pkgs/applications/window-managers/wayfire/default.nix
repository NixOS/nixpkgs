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
  libgbm,
  fetchpatch,
}:
let
  wlroots = wlroots_0_20;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire";
  version = "0.11.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-G6GakEpnqw3xORXP7mr2YoyAEymozV0CYeof+a1Nh74=";
  };

  patches = [
    (fetchpatch {
      name = "wayfire_fix_hermiticity";
      url = "https://github.com/WayfireWM/wayfire/commit/6cf51df330564d97d922cdaa84e0e130311d8337.patch";
      hash = "sha256-Drs5wuyF4cfzm3Jdv0fv05FeWjqNhHfVzJK7ZLM04v0=";
    })

    (fetchpatch {
      name = "wayfire_fix_squeezimize";
      url = "https://github.com/WayfireWM/wayfire/commit/2bd9c6d175a788ba057add7eb762e8b0ca4ea7cd.patch";
      hash = "sha256-pG6tnYiff9gj1AM6mNzhmU8JjoevSlMWeY0XREYq38Q=";
    })
  ];

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
    wayland-protocols
    libxkbcommon
    libgbm
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
