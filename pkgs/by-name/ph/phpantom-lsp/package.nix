{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  _experimental-update-script-combinators,
  nix-update-script,
  pkg-config,
  zstd,
}:
let
  stubsSrc = fetchFromGitHub {
    owner = "JetBrains";
    repo = "phpstorm-stubs";
    rev = "2049ca3cfa1feabf52db074108fe776a5713cf02";
    hash = "sha256-6mPZjMg0NBB55MUIbJIPGVIZCdiDQO79/MEiIzJDH24=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "phpantom-lsp";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PHPantom-dev";
    repo = "phpantom_lsp";
    tag = finalAttrs.version;
    hash = "sha256-YP+tkWJwuacDz3K0cLviWMIuUjmt1FHOdYda39wYa3I=";
  };

  postPatch = ''
    mkdir -p stubs/jetbrains
    cp -a ${finalAttrs.passthru.stubsSrc} stubs/jetbrains/phpstorm-stubs
    chmod u+wx stubs/jetbrains/phpstorm-stubs

    echo "${finalAttrs.passthru.stubsSrc.rev}" \
      > stubs/jetbrains/phpstorm-stubs/.commit
  '';

  cargoHash = "sha256-19HR5WlN9AMSZ90QRuCfo9NZMSyZzYao+cAhR0crTtM=";

  nativeBuildInputs = [ pkg-config ];

  env.ZSTD_SYS_USE_PKG_CONFIG = "1";
  buildInputs = [ zstd ];

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
