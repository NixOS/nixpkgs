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
    rev = "5f68c1021badebe34119fb8fa10ba7cc25de6c0c";
    hash = "sha256-GQW+N5FrWKf6PpLyhJ6Gywbe1lESwW/rxiv2ESNdH1s=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "phpantom-lsp";
  version = "0.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PHPantom-dev";
    repo = "phpantom_lsp";
    tag = finalAttrs.version;
    hash = "sha256-P5adooUaNCidGTIh/PDKzwvtIXCQ0y8tUMbLUC4sk98=";
  };

  postPatch = ''
    mkdir -p stubs/jetbrains
    cp -a ${finalAttrs.passthru.stubsSrc} stubs/jetbrains/phpstorm-stubs
    chmod u+wx stubs/jetbrains/phpstorm-stubs

    echo "${finalAttrs.passthru.stubsSrc.rev}" \
      > stubs/jetbrains/phpstorm-stubs/.commit
  '';

  cargoHash = "sha256-tZh1cn7Zu47FRVXozDjcoKW4MoxaaaxPmDX5OzlxnAs=";

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
