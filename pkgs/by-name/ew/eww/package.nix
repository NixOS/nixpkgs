{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  librsvg,
  gtk-layer-shell,
  stdenv,
  libdbusmenu-gtk3,
}:

rustPlatform.buildRustPackage rec {
  pname = "eww";
  version = "0.6.0-unstable-2024-04-26";

  src = fetchFromGitHub {
    owner = "elkowar";
    repo = "eww";
    # FIXME: change to a release tag once a new release is available
    # https://github.com/elkowar/eww/pull/1084
    # using the revision to fix string truncation issue in eww config
    rev = "2c8811512460ce6cc75e021d8d081813647699dc";
    hash = "sha256-eDOg5Ink3iWT/B1WpD9po5/UxS4DEaVO4NPIRyjSheM=";
  };

  cargoHash = "sha256-ClnIW7HxbQcC85OyoMhBLFjVtdEUCOARuimfS4uRi+E=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
    libdbusmenu-gtk3
    librsvg
  ];

  cargoBuildFlags = [
    "--bin"
    "eww"
  ];

  cargoTestFlags = cargoBuildFlags;

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = {
    description = "A widget system made in Rust to create widgets for any WM";
    longDescription = ''
      Eww (ElKowar's Wacky Widgets) is a widget system made in Rust which lets
      you create your own widgets similarly to how you can in AwesomeWM.
      The key difference: It is independent of your window manager!
      It can be configured in yuck and themed using CSS, is very easy
      to customize and provides all the flexibility you need!
    '';
    homepage = "https://github.com/elkowar/eww";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      coffeeispower
      eclairevoyant
      figsoda
      lom
      w-lfchen
    ];
    mainProgram = "eww";
    broken = stdenv.isDarwin;
  };
}
