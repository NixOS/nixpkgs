{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.107";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-expand";
    rev = version;
    hash = "sha256-oAZ7xt/Ji36XtGh7UXHbseBRQtpmsKHcAABiloITPXA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4HH25MEj3iCrm9iCW8vWVMDou/F3YidRIWDH0m5FTaY=";

  meta = {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      figsoda
      xrelkd
    ];
    mainProgram = "cargo-expand";
  };
}
