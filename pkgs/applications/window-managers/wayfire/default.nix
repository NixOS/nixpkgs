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
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots,
  pango,
  nlohmann_json,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-OPGzPy0I6i3TvmA5KSWDb4Lsf66zM5X+Akckgs3wk2o=";
  };

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
    wayland-protocols
    xorg.xcbutilwm
    nlohmann_json
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
      qyliss
      wucke13
      rewine
    ];
    platforms = lib.platforms.unix;
    mainProgram = "wayfire";
  };
})
