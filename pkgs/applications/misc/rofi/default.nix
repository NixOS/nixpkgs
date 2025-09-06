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
  wayland,
  wayland-protocols,
  wayland-scanner,
  which,
  withIMDKit ? true,
  withWayland ? true,
  withX11 ? true,
  xcb-imdkit,
  xcbutil,
  xcb-util-cursor,
  xcbutilkeysyms,
  xcbutilwm,
  xcbutilxrm,
}:

stdenv.mkDerivation rec {
  pname = "rofi-unwrapped";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "davatorium";
    repo = "rofi";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-akKwIYH9OoCh4ZE/bxKPCppxXsUhplvfRjSGsdthFk4=";
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
    xcbutil
    xcb-util-cursor
    xcbutilkeysyms
    xcbutilwm
    xcbutilxrm
  ]
  ++ lib.optionals withIMDKit [
    xcb-imdkit
  ]
  ++ lib.optionals withWayland [
    wayland
    wayland-protocols
    wayland-scanner
  ];

  mesonFlags =
    lib.optionals withIMDKit [ "-Dimdkit=true" ]
    ++ lib.optionals (!withWayland) [ "-Dwayland=disabled" ]
    ++ lib.optionals (!withX11) [ "-Dxcb=disabled" ];

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
