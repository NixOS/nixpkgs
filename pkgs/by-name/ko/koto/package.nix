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
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "koto-lang";
    repo = "koto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-47eDSohLH/cMmMwjUENNeT5danpgMKLPEMzEUACrpiY=";
  };

  cargoHash = "sha256-mQxPwU/f7/AastJmGBZOAxGKaZBWTQUkb2KIuC6MSfE=";

  postPatch = ''
    tomlq -ti 'del(.bench)' crates/koto/Cargo.toml
  '';

  nativeBuildInputs = [
    yq # for `tomlq`
  ];

  cargoBuildFlags = [ "--package=koto_cli" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple, expressive, embeddable programming language";
    homepage = "https://github.com/koto-lang/koto";
    changelog = "https://github.com/koto-lang/koto/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "koto";
  };
})
