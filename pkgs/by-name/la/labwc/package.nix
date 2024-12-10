{
  lib,
  cairo,
  fetchFromGitHub,
  gettext,
  glib,
  libdrm,
  libinput,
  libpng,
  librsvg,
  libxcb,
  libxkbcommon,
  libxml2,
  meson,
  ninja,
  pango,
  pkg-config,
  scdoc,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots,
  xcbutilwm,
  xwayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labwc";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc";
    rev = finalAttrs.version;
    hash = "sha256-8TSBBNg9+W65vEKmwyAWB2yEOpHqV9YRm5+ttL19ke4=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    cairo
    glib
    libdrm
    libinput
    libpng
    librsvg
    libxcb
    libxkbcommon
    libxml2
    pango
    wayland
    wayland-protocols
    wlroots
    xcbutilwm
    xwayland
  ];

  strictDeps = true;

  mesonFlags = [
    (lib.mesonEnable "xwayland" true)
  ];

  passthru = {
    providedSessions = [ "labwc" ];
  };

  meta = {
    homepage = "https://github.com/labwc/labwc";
    description = "A Wayland stacking compositor, inspired by Openbox";
    changelog = "https://github.com/labwc/labwc/blob/${finalAttrs.src.rev}/NEWS.md";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "labwc";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (wayland.meta) platforms;
  };
})
