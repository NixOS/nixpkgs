{
  lib,
  stdenv,
  callPackage,
  fetchFromCodeberg,
  libGL,
  libx11,
  libevdev,
  libinput,
  libxkbcommon,
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
  zig_0_16,
  withManpages ? true,
  xwaylandSupport ? true,
}:
let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "river";
  version = "0.4.5";

  outputs = [ "out" ] ++ lib.optionals withManpages [ "man" ];

  src = fetchFromCodeberg {
    owner = "river";
    repo = "river";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q4JAlr9/ex+BEgktBmFwOvZzQEAGvxXPD1QyKqyha4g=";
  };

  strictDeps = true;

  deps = callPackage ./build.zig.zon.nix { };

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

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ lib.optional withManpages "-Dman-pages"
  ++ lib.optional xwaylandSupport "-Dxwayland";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  postInstall = ''
    install contrib/river.desktop -Dt $out/share/wayland-sessions
  '';

  passthru = {
    providedSessions = [ "river" ];
    updateScript = ./update.sh;
  };

  meta = {
    description = "Non-monolithic Wayland compositor";
    homepage = "https://codeberg.org/river/river";
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
      adamcstephens
    ];
    mainProgram = "river";
    platforms = lib.platforms.linux;
  };
})
