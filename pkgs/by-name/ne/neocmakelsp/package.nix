{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "neocmakelsp";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "neocmakelsp";
    repo = "neocmakelsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OQ8DAM610YxilThJaAZ26NwOP6r/1k8Gzc0BEiCus+Q=";
  };

  cargoHash = "sha256-UbvabrM+rWAX80RjHW7uZJ8k4veAhp2LSX71ygvEjF8=";

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
