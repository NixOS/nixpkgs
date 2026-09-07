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
  __structuredAttrs = true;
  strictDeps = true;
  pname = "mango";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "mangowm";
    repo = "mango";
    tag = finalAttrs.version;
    hash = "sha256-tymTjjNKWohVzXycg2mN7cSApQ6NDmn9k4LklNq/WGo=";
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
    homepage = "https://mangowm.github.io";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      hustlerone
      samiser
    ];
    platforms = lib.platforms.linux;
  };
})
