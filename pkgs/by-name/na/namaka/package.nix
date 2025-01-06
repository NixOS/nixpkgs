{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  oniguruma,
}:

rustPlatform.buildRustPackage rec {
  pname = "namaka";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "namaka";
    rev = "v${version}";
    hash = "sha256-1ka+5B90UAt7D5kkT9dOExGLJjtLM8dqLeBdFRoeuWg=";
  };

  cargoHash = "sha256-Wo87OjHVKS2w0LeBvYEoV9eoKm8giqV/P9/mh6DueJ0=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    GEN_ARTIFACTS = "artifacts";
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  postInstall = ''
    installManPage artifacts/*.1
    installShellCompletion artifacts/namaka.{bash,fish} --zsh artifacts/_namaka
  '';

  meta = with lib; {
    description = "Snapshot testing tool for Nix based on haumea";
    mainProgram = "namaka";
    homepage = "https://github.com/nix-community/namaka";
    changelog = "https://github.com/nix-community/namaka/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
