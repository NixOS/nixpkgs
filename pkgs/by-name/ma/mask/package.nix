{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,

  # tests
  lua,
  nodejs,
  php,
  python3,
  ruby,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mask";
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "jacobdeichert";
    repo = "mask";
    tag = "mask/${finalAttrs.version}";
    hash = "sha256-jz2x3Do+fqDHS7vNdnZsNOj36dRFt/khFaF/ztyKji8=";
  };

  cargoHash = "sha256-HnRNg1/ZVWr6JRIsBf2kH9Xys7Hth4fMI12dClsPKv0=";

  preCheck = ''
    export PATH=$PATH:$PWD/target/${stdenv.hostPlatform.rust.rustcTarget}/$cargoBuildType
  '';

  nativeCheckInputs = [
    lua
    nodejs
    php
    python3
    ruby
  ];

  checkFlags = [
    # requires swift which currently fails to build
    "--skip=swift"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=^mask/(.*)$" ]; };

  meta = {
    description = "CLI task runner defined by a simple markdown file";
    mainProgram = "mask";
    homepage = "https://github.com/jacobdeichert/mask";
    changelog = "https://github.com/jacobdeichert/mask/blob/mask/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
  };
})
