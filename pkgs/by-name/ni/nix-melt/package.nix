{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-melt";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-melt";
    rev = "v${version}";
    hash = "sha256-jx7g9GOFAjOlJyNsGOUTLh2qWII9u0prOoBEvNPmdj8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-OTKK0d4yCTiK5GTw+LKagutRbok/zKqLkeOtInJ2L64=";

  nativeBuildInputs = [
    installShellFiles
  ];

  env = {
    GEN_ARTIFACTS = "artifacts";
  };

  postInstall = ''
    installManPage artifacts/nix-melt.1
    installShellCompletion artifacts/nix-melt.{bash,fish} --zsh artifacts/_nix-melt
  '';

  meta = with lib; {
    description = "Ranger-like flake.lock viewer";
    mainProgram = "nix-melt";
    homepage = "https://github.com/nix-community/nix-melt";
    changelog = "https://github.com/nix-community/nix-melt/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
