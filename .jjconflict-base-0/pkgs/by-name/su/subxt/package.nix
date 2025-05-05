{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "subxt";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    rev = "v${version}";
    hash = "sha256-zg2MraqKLbyhaxTi02rE4MsMuPw4diIseYNUQEoqnVA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-leJp+Ccb2mij46Cx6+pv7GoHLKG5IVlNeih0L2QQp4w=";

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
