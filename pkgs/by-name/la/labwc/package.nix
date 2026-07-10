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
  libsfdo,
  libxcb,
  libxkbcommon,
  libxml2,
  meson,
  ninja,
  pango,
  pkg-config,
  scdoc,
  stdenv,
  versionCheckHook,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots_0_20,
  libxcb-wm,
  xwayland,

  enableSystemd ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labwc";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc";
    tag = finalAttrs.version;
    hash = "sha256-JSs1Xys0+XAPbxLv5pR91K0/e78mu5xLKu0HGdFFCEM=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "install_dir: systemd.get_variable('systemduserunitdir')" \
                     "install_dir: '$out/lib/systemd/user'"
  '';

  outputs = [
    "out"
    "doc"
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
    libsfdo
    libxcb
    libxkbcommon
    libxml2
    pango
    wayland
    wayland-protocols
    wlroots_0_20
    libxcb-wm
    xwayland
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  mesonFlags = [
    (lib.mesonEnable "xwayland" true)
    (lib.mesonEnable "systemd-session" enableSystemd)
  ];

  strictDeps = true;

  doInstallCheck = true;

  passthru = {
    providedSessions = [ "labwc" ];
  };

  meta = {
    homepage = "https://github.com/labwc/labwc";
    description = "Wayland stacking compositor, inspired by Openbox";
    changelog = "https://github.com/labwc/labwc/blob/master/NEWS.md";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "labwc";
    maintainers = [ ];
    inherit (wayland.meta) platforms;
  };
})
