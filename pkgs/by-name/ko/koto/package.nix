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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "koto-lang";
    repo = "koto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KdwKJ0ZKKHU+Fe/TTIITHOyRH9uoJ3LU3qXqUwpJI6g=";
  };

  cargoHash = "sha256-5uWCpTnGbqoogOxSD2GcXMjQpoYIp1GfB9k4bd+Easc=";

  postPatch = ''
    tomlq -ti 'del(.bench)' crates/koto/Cargo.toml
  '';

  nativeBuildInputs = [
    yq # for `tomlq`
  ];

  cargoBuildFlags = [ "--package=koto_cli" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
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
