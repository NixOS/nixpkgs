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
  scenefx,
  wlroots_0_20,
  libGL,
}:
stdenv.mkDerivation (finalAttrs: {

  pname = "mango";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "mangowm";
    repo = "mango";
    tag = finalAttrs.version;
    hash = "sha256-0mX95LpyZuMMkEKS1qTiVrpDLeuCzO5hVJdmdpr7SY0=";
  };

  __structuredAttrs = true;
  strictDeps = true;

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
    scenefx
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
    homepage = finalAttrs.src.meta.homepage;
    changelog = "${finalAttrs.src.meta.homepage}/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      hustlerone
      yvnth
    ];
    platforms = lib.platforms.linux;
  };
})
