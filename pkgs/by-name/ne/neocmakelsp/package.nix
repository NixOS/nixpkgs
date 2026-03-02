{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "neocmakelsp";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dviHzaBqsE3NKRf4AeQme/oOcu5GyKjGJBui4ZjjDv8=";
  };

  cargoHash = "sha256-FE2DF/DnBKwW01N2wwurQ6F4qIFHMaoGZ1kb8vq86K8=";

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
})
