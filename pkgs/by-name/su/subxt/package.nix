{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "subxt";
  version = "0.42.1";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    rev = "v${version}";
    hash = "sha256-wp6gxIpo5MyODB/Gf6oh62iK/VmwjVaJkuysrytHKf4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1jat45mCpivEnKCp/9BfsW4ZXi0HF9PeAvK5gw5+enw=";

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
