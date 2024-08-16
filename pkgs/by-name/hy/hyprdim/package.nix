{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprdim";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = "hyprdim";
    rev = version;
    hash = "sha256-zE1GYgS3fFO6Zz1I5zr+ApEux9ndKOeegj2n/rF/4HY=";
  };

  cargoHash = "sha256-WchQXRlU/fkjnCOeP9E5JXVdM8UZlG3ixfLGHvmezHg=";

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
