{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.8.26";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-fJmkCi2xG0cJUxolhuT4Kuf0kK5tFLHcM9eFE1BDeFQ=";
  };

  cargoHash = "sha256-DEIQbnNDd1JQpeVLwvpQccZlIRb/e1JTQtYdi4UsJq8=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --bash completions/bash/neocmakelsp
    installShellCompletion --fish completions/fish/neocmakelsp.fish
    installShellCompletion --zsh completions/zsh/_neocmakelsp
  '';

  meta = {
    description = "CMake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      wineee
      multivac61
    ];
    mainProgram = "neocmakelsp";
  };
}
