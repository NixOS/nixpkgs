{
  lib,
  cairo,
  fetchFromSourcehut,
  librsvg,
  libxkbcommon,
  meson,
  ninja,
  pkg-config,
  scdoc,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lavalauncher";
  version = "2.1.1";

  src = fetchFromSourcehut {
    pname = "lavalauncher-source";
    inherit (finalAttrs) version;
    owner = "~leon_plickat";
    repo = "lavalauncher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hobhZ6s9m2xCdAurdj0EF1BeS88j96133zu+2jb1FMM=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    cairo
    librsvg
    libxkbcommon
    wayland
    wayland-protocols
  ];

  strictDeps = true;

  meta = {
    homepage = "https://git.sr.ht/~leon_plickat/lavalauncher";
    description = "Simple launcher panel for Wayland desktops";
    longDescription = ''
      LavaLauncher is a simple launcher panel for Wayland desktops.

      It displays a dynamically sized bar with user defined buttons. Buttons
      consist of an image, which is displayed as the button icon on the bar, and
      at least one shell command, which is executed when the user activates the
      button.

      Buttons can be activated with pointer and touch events.

      A single LavaLauncher instance can provide multiple such bars, across
      multiple outputs.

      The Wayland compositor must implement the Layer-Shell and XDG-Output for
      LavaLauncher to work.
    '';
    changelog = "https://git.sr.ht/~leon_plickat/lavalauncher/refs/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "lavalauncher";
    maintainers = with lib.maintainers; [ ];
    inherit (wayland.meta) platforms;
    # meson.build:52:23: ERROR: C shared or static library 'rt' not found
    # https://logs.ofborg.org/?key=nixos/nixpkgs.340239&attempt_id=1f05cada-67d2-4cfe-b6a8-4bf4571b9375
    broken = stdenv.hostPlatform.isDarwin;
  };
})
