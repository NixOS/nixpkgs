{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,

  # tests
  nodejs,
  python3,
  php,
  ruby,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mask";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "jacobdeichert";
    repo = "mask";
    tag = "mask/${finalAttrs.version}";
    hash = "sha256-xGD23pso5iS+9dmfTMNtR6YqUqKnzJTzMl+OnRGpL3g=";
  };

  cargoHash = "sha256-JaYr6J3NOwVIHzGO4wLkke5O/T/9WUDENPgLP5Fwyhg=";

  preCheck = ''
    export PATH=$PATH:$PWD/target/${stdenv.hostPlatform.rust.rustcTarget}/$cargoBuildType
  '';

  nativeCheckInputs = [
    nodejs
    python3
    php
    ruby
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=^mask/(.*)$" ]; };

  meta = {
    description = "CLI task runner defined by a simple markdown file";
    mainProgram = "mask";
    homepage = "https://github.com/jacobdeichert/mask";
    changelog = "https://github.com/jacobdeichert/mask/blob/mask/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      defelo
    ];
  };
})
