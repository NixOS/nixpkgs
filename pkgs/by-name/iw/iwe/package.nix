{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "iwe";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "iwe-org";
    repo = "iwe";
    tag = "iwe-v${version}";
    hash = "sha256-eE84KzYJTJ39UDQt3VZpSIba/P+7VFR9K6+MSMlg0Wc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-K8RxVYHh0pStQyHMiLLeUakAoK1IMoUtCNg70/NfDiI=";

  cargoBuildFlags = [
    "--package=iwe"
    "--package=iwes"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Personal knowledge management system (editor plugin & command line utility)";
    homepage = "https://iwe.md/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ phrmendes ];
    mainProgram = "iwe";
  };
}
