{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "subxt";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    rev = "v${version}";
    hash = "sha256-BV/zP0L0gDmLSuzkp4OkOPfgldXBUiaHL4rciM7lrno=";
  };

  cargoHash = "sha256-7kmxnlhgNj0hY9FwVrzmdHw73Jf/pSeTHi6sqDg9X24=";

  # Only build the command line client
  cargoBuildFlags = [
    "--bin"
    "subxt"
  ];

  # Needed by wabt-sys
  nativeBuildInputs = [ cmake ];

  # Requires a running substrate node
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/paritytech/subxt";
    description = "Submit transactions to a substrate node via RPC";
    mainProgram = "subxt";
    license = with licenses; [
      gpl3Plus
      asl20
    ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
