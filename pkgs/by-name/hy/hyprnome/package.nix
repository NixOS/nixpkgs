{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprnome";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = "hyprnome";
    rev = finalAttrs.version;
    hash = "sha256-GZn7qS1J6QSanWdy17sMBbwJ77iMij2jKRgPdrjt6tM=";
  };

  cargoHash = "sha256-qCexb8D0iN3BWOz5L45mR5n9x0nqAh8MHHTp9QTHSOg=";

  # Upstream has 'missing_docs = "deny"', which trips up test builds for 0.3.1 release.
  # Let's just treat lints as warnings.
  env.RUSTFLAGS = "--cap-lints warn";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage target/man/hyprnome.1

    installShellCompletion --cmd hyprnome \
      --bash target/completions/hyprnome.bash \
      --fish target/completions/hyprnome.fish \
      --zsh target/completions/_hyprnome
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GNOME-like workspace switching in Hyprland";
    homepage = "https://github.com/donovanglover/hyprnome";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "hyprnome";
  };
})
