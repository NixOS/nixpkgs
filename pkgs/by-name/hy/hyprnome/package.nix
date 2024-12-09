{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprnome";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = "hyprnome";
    rev = version;
    hash = "sha256-GZn7qS1J6QSanWdy17sMBbwJ77iMij2jKRgPdrjt6tM=";
  };

  cargoHash = "sha256-oxIZTp5ZJRUjXLpMw2nOnPHYHhHN03HWFRhBZ82Ac10=";

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
