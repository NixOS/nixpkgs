{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprdim";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = "hyprdim";
    rev = version;
    hash = "sha256-+nzIDtRLVA6CgCtbyeR+TU5euSZQb7wi2187IxLrAmQ=";
  };

  cargoHash = "sha256-UhlwVZ70t6CSQ4ZoXk0OdUqEVeOVMp+TmOSX5iyNNVI=";

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
