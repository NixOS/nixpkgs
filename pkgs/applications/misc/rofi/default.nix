{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libxkbcommon,
  pango,
  which,
  git,
  cairo,
  libxcb,
  xcb-util-cursor,
  xcbutilkeysyms,
  xcbutil,
  xcbutilwm,
  xcbutilxrm,
  libstartup_notification,
  bison,
  flex,
  librsvg,
  check,
  glib,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "rofi-unwrapped";
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "davatorium";
    repo = "rofi";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-2rPEn+XotijqLYo2EcoiJbgdbRk4SCQ+D4jZ1gwpCQw=";
  };

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  depsBuildBuild = [
    buildPackages.stdenv.cc
    pkg-config
    glib
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    flex
    bison
  ];
  buildInputs = [
    libxkbcommon
    pango
    cairo
    git
    librsvg
    check
    libstartup_notification
    libxcb
    xcb-util-cursor
    xcbutilkeysyms
    xcbutil
    xcbutilwm
    xcbutilxrm
    which
  ];

  doCheck = false;

  meta = {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = "https://github.com/davatorium/rofi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bew ];
    platforms = with lib.platforms; linux;
    mainProgram = "rofi";
  };
}
