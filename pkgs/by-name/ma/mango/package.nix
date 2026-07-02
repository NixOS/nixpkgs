{
  cjson,
  lib,
  libx11,
  libinput,
  libxcb,
  libxkbcommon,
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
  scenefx,
  wlroots_0_19,
  libGL,
}:
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;
  pname = "mango";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "mangowm";
    repo = "mango";
    tag = finalAttrs.version;
    hash = "sha256-WfQNALT+8ZbjZG2co1tz2dZZZw1tcU5ynuFe+vVMbV0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    cjson
    libinput
    libxcb
    libxkbcommon
    pcre2
    pixman
    wayland
    wayland-protocols
    wlroots_0_19
    scenefx
    libGL
  ]
  ++ lib.optionals enableXWayland [
    libx11
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
