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
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "koto-lang";
    repo = "koto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sFADZj0mBe8TQ2x6NeXLqvvXK13WhVGD2anGWoWrSZw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ok4rgqiQ7N5knXdb0Mfn3fYPPLXoRtOZVv8RvWR2h3k=";

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
