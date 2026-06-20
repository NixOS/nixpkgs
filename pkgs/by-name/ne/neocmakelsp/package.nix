{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "neocmakelsp";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HfoVAUg9StAUXmP66LVRzCj4sd4kl6pCzWUS3lZEKtU=";
  };

  cargoHash = "sha256-yddefmK5ftu1rUpK3QcjocJiWQq5Y9CTJGjn2LbubbU=";

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
