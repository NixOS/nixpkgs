{
  lib,
  stdenv,
  callPackage,
  fetchFromGitea,
  libGL,
  libX11,
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
  pname = "river-classic";
  version = "0.3.12";

  outputs = [ "out" ] ++ lib.optionals withManpages [ "man" ];

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "river";
    repo = "river-classic";
    hash = "sha256-ZYJYQINv6aNj8jyPOtMh5kf/HweIweTztWUStbr/9Zc=";
    tag = "v${finalAttrs.version}";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    xwayland
    zig_0_15.hook
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
  ++ lib.optional xwaylandSupport libX11;

  dontConfigure = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ lib.optional withManpages "-Dman-pages"
  ++ lib.optional xwaylandSupport "-Dxwayland";

  postInstall = ''
    install contrib/river.desktop -Dt $out/share/wayland-sessions
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru = {
    providedSessions = [ "river" ];
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://codeberg.org/river/river-classic";
    description = "Dynamic tiling wayland compositor";
    longDescription = ''
      river-classic is a dynamic tiling Wayland compositor with flexible runtime
      configuration.

      It is a fork of river 0.3 intended for users that are happy with how river 0.3
      works and do not wish to deal with the majorly breaking changes planned for
      the river 0.4.0 release.
    '';
    changelog = "https://codeberg.org/river/river-classic/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      adamcstephens
      moni
      rodrgz
    ];
    mainProgram = "river";
    platforms = lib.platforms.linux;
  };
})
