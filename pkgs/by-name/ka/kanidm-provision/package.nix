{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "kanidm-provision";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "oddlama";
    repo = "kanidm-provision";
    rev = "v${version}";
    hash = "sha256-tX24cszmWu7kB5Eoa3OrPqU1bayD62OpAV12U0ayoEo=";
  };

  cargoHash = "sha256-Ok8A47z5Z3QW4teql/4RyDlox/nrhkdA6IN/qJm13bM=";

  meta = with lib; {
    description = "A small utility to help with kanidm provisioning";
    homepage = "https://github.com/oddlama/kanidm-provision";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ oddlama ];
    mainProgram = "kanidm-provision";
  };
}
