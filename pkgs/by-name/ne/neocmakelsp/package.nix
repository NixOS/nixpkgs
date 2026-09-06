{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "neocmakelsp";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "neocmakelsp";
    repo = "neocmakelsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-61sTd3FIjoNKzOFp/Z6UUDa9NOWJPVal4Wf9UZ66gqU=";
  };

  cargoHash = "sha256-HYAVuWIFVp4Br3lDqb2r3xion2Rz6ChrgVIj3Z8wymE=";

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
    homepage = "https://github.com/neocmakelsp/neocmakelsp";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      wineee
      multivac61
    ];
    mainProgram = "neocmakelsp";
  };
})
