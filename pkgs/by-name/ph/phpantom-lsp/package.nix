{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  _experimental-update-script-combinators,
  nix-update-script,
}:

let
  stubsSrc = fetchFromGitHub {
    owner = "JetBrains";
    repo = "phpstorm-stubs";
    rev = "3327932472f512d2eb9e122b19702b335083fd9d";
    hash = "sha256-WN5DAvaw4FfHBl2AqSo1OcEthUm3lOpikdB78qy3cyY=";
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "phpantom-lsp";
  version = "0.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AJenbo";
    repo = "phpantom_lsp";
    tag = finalAttrs.version;
    hash = "sha256-ZmtOdoxXkwn2IDg7RyQ9KG0RNz5mrGDMcESfcOSR3Ig=";
  };

  postPatch = ''
    mkdir -p stubs/jetbrains
    cp -a ${finalAttrs.passthru.stubsSrc} stubs/jetbrains/phpstorm-stubs
    chmod u+wx stubs/jetbrains/phpstorm-stubs

    echo "${finalAttrs.passthru.stubsSrc.rev}" \
      > stubs/jetbrains/phpstorm-stubs/.commit
  '';

  cargoHash = "sha256-pXP4qItYgmUXVx9XwMdS6WLVc5lP7P4VX9+0TbhYrUc=";

  checkFlags = [
    "--test"
    "completion_inheritance"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    inherit stubsSrc;
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      ./update-php-stubs.sh
    ];
  };

  meta = {
    changelog = "https://github.com/AJenbo/phpantom_lsp/releases/tag/${finalAttrs.src.tag}";
    description = "Fast, lightweight PHP language server written in Rust";
    homepage = "https://github.com/AJenbo/phpantom_lsp";
    license = lib.licenses.mit;
    mainProgram = "phpantom_lsp";
    maintainers = with lib.maintainers; [ nanoyaki ];
  };
})
