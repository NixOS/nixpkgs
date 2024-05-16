{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprnome";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = "hyprnome";
    rev = version;
    hash = "sha256-J/gaAwydSA9fi2qZYrWLpodTltL56yG4VQ2YlIPKJ/U=";
  };

  cargoHash = "sha256-Fyst6rwpvVQoeWCOkJwpNuMcnp6Q+kAXtDg+fccTVNM=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage target/man/hyprnome.1

    installShellCompletion --cmd hyprnome \
      --bash target/completions/hyprnome.bash \
      --fish target/completions/hyprnome.fish \
      --zsh target/completions/_hyprnome
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "GNOME-like workspace switching in Hyprland";
    homepage = "https://github.com/donovanglover/hyprnome";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "hyprnome";
  };
}
