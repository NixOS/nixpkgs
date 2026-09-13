{
  lib,
  fetchFromCodeberg,
  libinput,
  libx11,
  libxcb,
  libxcb-wm,
  libxkbcommon,
  nix-update-script,
  nixosTests,
  pixman,
  pkg-config,
  stdenv,
  versionCheckHook,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots_0_19,
  writeText,
  xwayland,
  # Boolean flags
  enableXWayland ? true,
  # Configurable options
  configH ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dwl";
  version = "0.8";

  strictDeps = true;

  # required for whitespaces in makeFlags
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "dwl";
    repo = "dwl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J76L5ZOCYgfcY08wH5cSLG+UdgDrv50lQyEnJNqDkXI=";
  };

  postPatch =
    let
      configFile =
        if lib.isDerivation configH || builtins.isPath configH then
          configH
        else
          writeText "config.h" configH;
    in
    lib.optionalString (configH != null) "cp ${configFile} config.h";

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libinput
    libxcb
    libxkbcommon
    pixman
    wayland
    wayland-protocols
    wlroots_0_19
  ]
  ++ lib.optionals enableXWayland [
    libx11
    libxcb-wm
    xwayland
  ];

  makeFlags = [
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
    "WAYLAND_SCANNER=wayland-scanner"
    "PREFIX=$(out)"
    "MANDIR=$(man)/share/man"
  ]
  ++ lib.optionals enableXWayland [
    ''XWAYLAND="-DXWAYLAND"''
    ''XLIBS="xcb xcb-icccm"''
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  # `dwl -v` emits its version string to stderr and returns 1
  versionCheckProgramArg = "-v";

  passthru = {
    tests.basic = nixosTests.dwl;
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://codeberg.org/dwl/dwl";
    changelog = "https://codeberg.org/dwl/dwl/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Dynamic window manager for Wayland";
    longDescription = ''
      dwl is a compact, hackable compositor for Wayland based on wlroots. It is
      intended to fill the same space in the Wayland world that dwm does in X11,
      primarily in terms of philosophy, and secondarily in terms of
      functionality. Like dwm, dwl is:

      - Easy to understand, hack on, and extend with patches
      - One C source file (or a very small number) configurable via config.h
      - Tied to as few external dependencies as possible
    '';
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ miniharinn ];
    inherit (wayland.meta) platforms;
    mainProgram = "dwl";
  };
})
# TODO: custom patches from upstream website
