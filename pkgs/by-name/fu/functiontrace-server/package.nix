{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "functiontrace-server";
  version = "0.5.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-p6ypMfg99ohQCyPB2O0wXbGmPvD2K9V3EnFDd5dC6js=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-sPleuZV7eXlQjKqeHCIlRwu1FzneBh460yAElnxi6Do=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  meta = with lib; {
    description = "Server for FunctionTrace, a graphical Python profiler";
    homepage = "https://functiontrace.com";
    license = with licenses; [ prosperity30 ];
    maintainers = with maintainers; [ tehmatt ];
  };
}
