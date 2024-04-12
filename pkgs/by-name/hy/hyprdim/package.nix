{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprdim";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = "hyprdim";
    rev = version;
    hash = "sha256-XRaBrn8gnXyMiCf3UQvdZGnZ//YMUivfVg0IoZF5F88=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hyprland-0.3.13" = "sha256-gjShmFcECdX0/t7mL035l9e9OzZuJqX0Ueozv38l03g=";
    };
  };

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
