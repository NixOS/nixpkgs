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
    rev = "f6dd2dd35d99fb774251a83555fe07bf2109d57e";
    hash = "sha256-H9Td/yi9Um0Z9ifxZdh74bvGCMVSC+MA1OHrtbGD8vE=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "phpantom-lsp";
  version = "0.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PHPantom-dev";
    repo = "phpantom_lsp";
    tag = finalAttrs.version;
    hash = "sha256-euWaFH40VHefZewUcKvsLwwHZP+GwfTN8kfuAkaABB8=";
  };

  postPatch = ''
    mkdir -p stubs/jetbrains
    cp -a ${finalAttrs.passthru.stubsSrc} stubs/jetbrains/phpstorm-stubs
    chmod u+wx stubs/jetbrains/phpstorm-stubs

    echo "${finalAttrs.passthru.stubsSrc.rev}" \
      > stubs/jetbrains/phpstorm-stubs/.commit
  '';

  cargoHash = "sha256-2MIJxVRqyCv5HzCwY1s+rCp1A4vFRsyAEEuyIEegZMA=";

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
    changelog = "https://github.com/PHPantom-dev/phpantom_lsp/releases/tag/${finalAttrs.src.tag}";
    description = "Fast, lightweight PHP language server written in Rust";
    homepage = "https://github.com/PHPantom-dev/phpantom_lsp";
    license = lib.licenses.mit;
    mainProgram = "phpantom_lsp";
    maintainers = with lib.maintainers; [ nanoyaki ];
  };
})
