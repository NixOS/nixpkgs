{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  oniguruma,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "neocmakelsp";
  version = "0.11.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "neocmakelsp";
    repo = "neocmakelsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AgwrIdEh2w92hr9SFnpOnsR48yTyInkD/6uaWeGc0mQ=";
  };

  cargoHash = "sha256-sZiGeo2OhnyvwwSd86WGVo3UAZKLQt2g9zBecBQLzrQ=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ oniguruma ];

  postInstall = ''
    installShellCompletion --bash completions/bash/neocmakelsp
    installShellCompletion --fish completions/fish/neocmakelsp.fish
    installShellCompletion --zsh completions/zsh/_neocmakelsp
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "CMake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/neocmakelsp/neocmakelsp";
    changelog = "https://github.com/neocmakelsp/neocmakelsp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      wineee
      multivac61
    ];
    mainProgram = "neocmakelsp";
  };
})
