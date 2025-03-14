{
  lib,
  rustPlatform,
  fetchFromGitHub,
  yq,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "koto";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "koto-lang";
    repo = "koto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T8SjNeoTANAcT+uAdgzBRMK0LbC038cpKFoCFHgsp8k=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kIjDY27ot1dN3L8TKaBEQWDzo7+QIFvhdmi1YN9TofI=";

  postPatch = ''
    ${lib.getExe' yq "tomlq"} -ti 'del(.bench)' crates/koto/Cargo.toml
  '';

  cargoBuildFlags = [ "--package=koto_cli" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple, expressive, embeddable programming language";
    homepage = "https://github.com/koto-lang/koto";
    changelog = "https://github.com/koto-lang/koto/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "koto";
  };
})
