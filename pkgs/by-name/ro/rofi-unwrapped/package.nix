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
  versionCheckHook,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-unwrapped";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "davatorium";
    repo = "rofi";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-akKwIYH9OoCh4ZE/bxKPCppxXsUhplvfRjSGsdthFk4=";
  };

  preConfigure = ''
    patchShebangs "script"

    # root not present in build /etc/passwd
    substituteInPlace test/helper-expand.c \
      --replace-fail "~root" "~nobody"
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
  ]
  ++ lib.optionals waylandSupport [
    wayland-protocols
    wayland-scanner
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

  mesonFlags = [
    (lib.mesonBool "imdkit" x11Support)
    (lib.mesonEnable "wayland" waylandSupport)
    (lib.mesonEnable "xcb" x11Support)
  ];

  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  meta = {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = "https://github.com/davatorium/rofi";
    changelog = "https://github.com/davatorium/rofi/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bew
      SchweGELBin
    ];
    platforms = lib.platforms.linux;
    mainProgram = "rofi";
  };
})
