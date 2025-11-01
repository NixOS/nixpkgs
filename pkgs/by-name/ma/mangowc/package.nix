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
  mmsg,
  scenefx,
  wlroots_0_19,
  libGL,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mangowc";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "DreamMaoMao";
    repo = "mangowc";
    rev = "${finalAttrs.version}";
    hash = "sha256-lpvUIyEPn2uXLpPEGkFsQvdEhht6rE+0RqhS8s7ZOd8=";
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

  passthru = {
    providedSessions = [ "mangowc" ];
    inherit mmsg;
  };

  meta = {
    mainProgram = "mango";
    description = "A streamlined but feature-rich Wayland compositor";
    homepage = "https://github.com/DreamMaoMao/mangowc";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hustlerone ];
    platforms = lib.platforms.unix;
  };
})
