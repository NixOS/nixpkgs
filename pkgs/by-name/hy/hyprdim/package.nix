{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprdim";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = "hyprdim";
    rev = version;
    hash = "sha256-EWZnimLLV879FiZUax1YK5ML/Qz4qt29rJWn5uoKtqw=";
  };

  cargoHash = "sha256-V4Z3PKavxfQm7zSoTyoWtxpc8yuuGPemO4OdadQEVdg=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage target/man/hyprdim.1

    installShellCompletion --cmd hyprdim \
      --bash target/completions/hyprdim.bash \
      --fish target/completions/hyprdim.fish \
      --zsh target/completions/_hyprdim
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Automatically dim windows in Hyprland when switching between them";
    homepage = "https://github.com/donovanglover/hyprdim";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "hyprdim";
  };
}
