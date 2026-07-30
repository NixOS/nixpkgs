{
  cjson,
  lib,
  libdrm,
  libinput,
  libxcb,
  libxkbcommon,
  pango,
  pcre2,
  pixman,
  pkg-config,
  stdenv,
  fetchFromGitHub,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxcb-wm,
  xwayland,
  enableXWayland ? true,
  meson,
  ninja,
  scenefx_0_5,
  wlroots_0_20,
  libGL,
}:
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;
  pname = "mango";
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "mangowm";
    repo = "mango";
    tag = finalAttrs.version;
    hash = "sha256-dg2cRIOPqjW/Q+5NLS8OWfIyVsRoGZT1Dji8SSVnpmE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    cjson
    libdrm
    libinput
    libxkbcommon
    pango
    pcre2
    pixman
    wayland
    wayland-protocols
    wlroots_0_20
    scenefx_0_5
    libGL
  ]
  ++ lib.optionals enableXWayland [
    libxcb
    libxcb-wm
    xwayland
  ];

  mesonFlags = [
    (lib.mesonEnable "xwayland" enableXWayland)
  ];

  passthru = {
    providedSessions = [
      "mango"
    ];
  };

  meta = {
    mainProgram = "mango";
    description = "Lightweight and feature-rich Wayland compositor based on dwl";
    homepage = "https://mangowm.github.io";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      hustlerone
      yvnth
    ];
    platforms = lib.platforms.linux;
  };
})
