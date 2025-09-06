{
  lib,
  stdenv,
  bison,
  buildPackages,
  cairo,
  check,
  fetchFromGitHub,
  flex,
  git,
  glib,
  librsvg,
  libstartup_notification,
  libxcb,
  libxkbcommon,
  meson,
  ninja,
  pandoc,
  pango,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  which,
  xcb-imdkit,
  xcbutil,
  xcb-util-cursor,
  xcbutilkeysyms,
  xcbutilwm,
  xcbutilxrm,
  waylandSupport ? true,
  x11Support ? true,
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
    libxkbcommon
    pango
    which
  ]
  ++ lib.optionals waylandSupport [
    wayland
    wayland-protocols
    wayland-scanner
  ]
  ++ lib.optionals x11Support [
    libxcb
    xcb-imdkit
    xcbutil
    xcb-util-cursor
    xcbutilkeysyms
    xcbutilwm
    xcbutilxrm
  ];

  mesonFlags =
    lib.optionals x11Support [ "-Dimdkit=true" ]
    ++ lib.optionals (!waylandSupport) [ "-Dwayland=disabled" ]
    ++ lib.optionals (!x11Support) [ "-Dxcb=disabled" ];

  doCheck = false;

  meta = with lib; {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = "https://github.com/davatorium/rofi";
    license = licenses.mit;
    maintainers = with maintainers; [
      bew
      SchweGELBin
    ];
    platforms = with platforms; linux;
    mainProgram = "rofi";
  };
}
