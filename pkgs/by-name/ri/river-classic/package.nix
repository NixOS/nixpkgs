{
  callPackage,
  fetchFromCodeberg,
  lib,
  libGL,
  libevdev,
  libinput,
  libx11,
  libxkbcommon,
  pixman,
  pkg-config,
  scdoc,
  stdenv,
  udev,
  versionCheckHook,
  wayland,
  wayland-protocols,
  wayland-scanner,
  withManpages ? true,
  wlroots_0_20,
  xwayland,
  xwaylandSupport ? true,
  zig_0_16,
}:
let
  wlroots = wlroots_0_20;
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "river-classic";
  version = "0.3.16";

  outputs = [ "out" ] ++ lib.optionals withManpages [ "man" ];

  src = fetchFromCodeberg {
    owner = "river";
    repo = "river-classic";
    hash = "sha256-MbUKs9zNGiC2bzQf2+rX6zlsJpJkmUkqPxGpJti4Odc=";
    tag = "v${finalAttrs.version}";
  };

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
    wlroots
  ]
  ++ lib.optional xwaylandSupport libx11;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ lib.optional withManpages "-Dman-pages"
  ++ lib.optional xwaylandSupport "-Dxwayland";

  postInstall = ''
    install -Dm644 contrib/river.desktop --target-directory=$out/share/wayland-sessions
    install -Dm755 example/init --target-directory=$out/example
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
    longDescription = ''
      river-classic is a dynamic tiling Wayland compositor with
      flexible runtime configuration.

      It is a fork of [river](https://codeberg.org/river/river) 0.3
      intended for users that are happy with how river 0.3 works and
      do not wish to deal with the majorly breaking changes from the
      river 0.4.0 release.
    '';
    changelog = "https://codeberg.org/river/river-classic/releases/tag/v${finalAttrs.version}";
    homepage = "https://codeberg.org/river/river-classic";
    license = lib.licenses.gpl3Only;
    mainProgram = "river";
    maintainers = with lib.maintainers; [
      adamcstephens
      moni
      rodrgz
    ];
    platforms = lib.platforms.linux;
  };
})
