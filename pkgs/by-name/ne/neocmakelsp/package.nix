{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "neocmakelsp";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "neocmakelsp";
    repo = "neocmakelsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AgwrIdEh2w92hr9SFnpOnsR48yTyInkD/6uaWeGc0mQ=";
  };

  cargoHash = "sha256-sZiGeo2OhnyvwwSd86WGVo3UAZKLQt2g9zBecBQLzrQ=";

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
