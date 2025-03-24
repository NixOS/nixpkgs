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
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "nik-rev";
    repo = "countryfetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KdFgY54vXLmq6IZfJzZ1IeZ2eQuNJoCRZUV3rVuPpcY=";
  };

  postPatch = ''
    tomlq -ti '.dependencies.openssl.features[] |= select(.!="vendored")' countryfetch/Cargo.toml
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-XJI9k/5hdak8p0/J/x9u6lqJu/DIbX93Wwm3LALkAAw=";

  env.RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    pkg-config
    yq # for `tomlq`
  ];

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
