{
  lib,
  rustPlatform,
  fetchFromGitHub,
  yq,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "countryfetch";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "nik-rev";
    repo = "countryfetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eG0h+vEJlQbZHQsbHrd0PWeZh61kd2FscMujbKSmm2M=";
  };

  postPatch = ''
    find -name Cargo.toml -exec sed -i '1icargo-features = ["edition2024"]' {} \;
    ${lib.getExe' yq "tomlq"} -ti '.dependencies.openssl.features[] |= select(.!="vendored")' countryfetch/Cargo.toml
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-cRUjjqrnWTuPoNLupm3megQnQNNWr2t25lut60XYpa8=";

  env.RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  cargoBuildFlags = [ "--package=countryfetch" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool similar to Neofetch for obtaining information about your country";
    homepage = "https://github.com/nik-rev/countryfetch";
    changelog = "https://github.com/nik-rev/countryfetch/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "countryfetch";
  };
})
