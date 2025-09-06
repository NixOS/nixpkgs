{
  bison,
  buildPackages,
  cairo,
  check,
  fetchFromGitHub,
  flex,
  git,
  glib,
  lib,
  librsvg,
  libstartup_notification,
  libxcb,
  libxkbcommon,
  meson,
  ninja,
  pandoc,
  pango,
  pkg-config,
  stdenv,
  which,
  xcb-imdkit,
  xcbutil,
  xcb-util-cursor,
  xcbutilkeysyms,
  xcbutilwm,
  xcbutilxrm,
}:

stdenv.mkDerivation rec {
  pname = "rofi-unwrapped";
  version = "1.7.9.1";

  src = fetchFromGitHub {
    owner = "davatorium";
    repo = "rofi";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-HZMVGlK6ig7kWf/exivoiTe9J/SLgjm7VwRm+KgKN44=";
  };

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  depsBuildBuild = [
    buildPackages.stdenv.cc
    glib
    pkg-config
  ];
  nativeBuildInputs = [
    bison
    flex
    meson
    ninja
    pandoc
    pkg-config
  ];
  buildInputs = [
    cairo
    check
    git
    librsvg
    libstartup_notification
    libxcb
    libxkbcommon
    pango
    which
    xcb-imdkit
    xcbutil
    xcb-util-cursor
    xcbutilkeysyms
    xcbutilwm
    xcbutilxrm
  ];

  mesonFlags = [ "-Dimdkit=true" ];

  doCheck = false;

  meta = with lib; {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = "https://github.com/davatorium/rofi";
    license = licenses.mit;
    maintainers = with maintainers; [ bew ];
    platforms = with platforms; linux;
    mainProgram = "rofi";
  };
}
