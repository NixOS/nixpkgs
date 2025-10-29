{
  fetchCrate,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo2junit";
  version = "0.1.13";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-R3a87nXCnGhdeyR7409hFR5Cj3TFUWqaLNOtlXPsvto=";
  };

  cargoPatches = [
    ./0001-update-time-rs.patch
  ];

  cargoHash = "sha256-FPCLy4mIuUeHMuYgYGTs/fn8tUf55LVWBwrrA5hiG2k=";

  meta = with lib; {
    description = "Converts cargo's json output (from stdin) to JUnit XML (to stdout)";
    mainProgram = "cargo2junit";
    homepage = "https://github.com/johnterickson/cargo2junit";
    license = licenses.mit;
    maintainers = with maintainers; [ alekseysidorov ];
  };
}
