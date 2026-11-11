{
  lib,
  stdenv,
  fetchFromCodeberg,
  libGL,
  libx11,
  libevdev,
  libinput,
  libxkbcommon,
  nix-update-script,
  pixman,
  pkg-config,
  scdoc,
  udev,
  versionCheckHook,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots_0_20,
  xwayland,
  zig_0_17,
  withManpages ? true,
  xwaylandSupport ? true,
}:
let
  zig = zig_0_17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "river";
  version = "0.5.2";
  __structuredAttrs = true;

  outputs = [ "out" ] ++ lib.optionals withManpages [ "man" ];

  src = fetchFromCodeberg {
    owner = "river";
    repo = "river";
    tag = "v${finalAttrs.version}";
    hash = "sha256-60ezbC1xntng5tOUzk20J881mGljc9UZIE5EuzwY9mY=";
  };

  strictDeps = true;

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-m9qXQPqrZzw7N0VjfCFJ3PZKbb3udzR0r8Xys4YEGL4=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    xwayland
    zig
  ]
  ++ lib.optional withManpages scdoc;

  buildInputs = [
    libGL
    libevdev
    libinput
    libxkbcommon
    pixman
    udev
    wayland
    wayland-protocols
    wayland-scanner
    wlroots_0_20
  ]
  ++ lib.optionals xwaylandSupport [
    libx11
  ];

  zigBuildFlags =
    lib.optionals withManpages [
      "-Dman-pages"
    ]
    ++ lib.optionals xwaylandSupport [
      "-Dxwayland"
    ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  postInstall = ''
    install contrib/river.desktop -Dt $out/share/wayland-sessions
  '';

  passthru = {
    providedSessions = [ "river" ];
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Non-monolithic Wayland compositor";
    homepage = "https://codeberg.org/river/river";
    donationPage = "https://codeberg.org/river/river#donate";
    longDescription = ''
      River is a non-monolithic Wayland compositor.
      Unlike other Wayland compositors, river does not combine the compositor and window manager into one program.
      Instead, users can choose any window manager implementing the river-window-management-v1 protocol.
    '';
    changelog = "https://codeberg.org/river/river/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      # source code
      gpl3Only

      # wayland protocols
      mit
    ];
    maintainers = with lib.maintainers; [
      GaetanLepage
    ];
    mainProgram = "river";
    platforms = lib.platforms.linux;
  };
})
