{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "countryfetch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nik-rev";
    repo = "countryfetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-povKd1Y/2Mi+6yJd9+RsJ4F19/wvXvBOK2Jgbs4UnP0=";
  };

  cargoHash = "sha256-0ZBhRheJGapPqVieXbIpoboVV4RLXan042u5SSgrYQk=";

  env = {
    OPENSSL_NO_VENDOR = true;
  };

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
