{
  lib,
  libX11,
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
  xcbutilwm,
  xwayland,
  enableXWayland ? true,
  meson,
  ninja,
  scenefx,
  wlroots_0_19,
  libGL,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mangowc";
<<<<<<< HEAD
  version = "0.10.8";
=======
  version = "0.10.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "DreamMaoMao";
    repo = "mangowc";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-Vszn4Zp0pojvvKkyP7M7V5iqNRB0kUvwd9iez+KzOyM=";
=======
    hash = "sha256-ZESyUtCiIQh6R0VYAo8YaP95Damw3MJVvKy5qU3pgTA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
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
    libX11
    xcbutilwm
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
    homepage = "https://github.com/DreamMaoMao/mangowc";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hustlerone ];
    platforms = lib.platforms.linux;
  };
})
