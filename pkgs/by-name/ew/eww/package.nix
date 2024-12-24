{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  librsvg,
  gtk-layer-shell,
  stdenv,
  libdbusmenu-gtk3,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "eww";
  version = "0.6.0-unstable-2024-07-05";

  src = fetchFromGitHub {
    owner = "elkowar";
    repo = "eww";
    # FIXME: change to a release tag once a new release is available
    # https://github.com/elkowar/eww/pull/1084
    # using the revision to fix string truncation issue in eww config
    rev = "4d55e9ad63d1fae887726dffcd25a32def23d34f";
    hash = "sha256-LTSFlW/46hl1u9SzqnvbtNxswCW05bhwOY6CzVEJC5o=";
  };

  # needed to fix build errors with rust 1.80 due to outdated time crate
  cargoPatches = [ ./lockfile.patch ];
  cargoHash = "sha256-55lmQl5pJwrEj5RlSG8b0PqtZVrASxTmX4Qdk090DZo=";

  nativeBuildInputs = [
    installShellFiles
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

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd eww \
      --bash <($out/bin/eww shell-completions --shell bash) \
      --fish <($out/bin/eww shell-completions --shell fish) \
      --zsh <($out/bin/eww shell-completions --shell zsh)
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Widget system made in Rust to create widgets for any WM";
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
      figsoda
      lom
      w-lfchen
    ];
    mainProgram = "eww";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
