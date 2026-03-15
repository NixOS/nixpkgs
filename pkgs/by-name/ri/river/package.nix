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
  wlroots_0_19,
  xwayland,
  zig_0_15,
  withManpages ? true,
  xwaylandSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "river";
  version = "0.4.0";

  outputs = [ "out" ] ++ lib.optionals withManpages [ "man" ];

  src = fetchFromCodeberg {
    owner = "river";
    repo = "river";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I0o8kxPafJ+EaUwVdHq2qx8jV8TNK0v+u4HoJ5I4/GE=";
  };

  strictDeps = true;

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    xwayland
    zig_0_15
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
    wlroots_0_19
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

  postInstall = ''
    install contrib/river.desktop -Dt $out/share/wayland-sessions
    install -Dm755 example/init -t $out/example/
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru = {
    providedSessions = [ "river" ];
    updateScript = ./update.sh;
  };

  meta = {
    description = "Dynamic tiling wayland compositor";
    homepage = "https://codeberg.org/river/river";
    longDescription = ''
      river is a dynamic tiling Wayland compositor with flexible runtime
      configuration.
    '';
    changelog = "https://codeberg.org/river/river/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
    ];
    mainProgram = "river";
    platforms = lib.platforms.linux;
  };
})
