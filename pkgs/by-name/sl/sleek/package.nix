{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "sleek";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "nrempel";
    repo = "sleek";
    rev = "v${version}";
    hash = "sha256-U1ujR+6wW3SKUnjqs/+DrEhu0XRBB8hxGC2pxe3LVbw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2P47kVNQPksKyWPtk1XEpVEjFfz7cEvWX0VvlT3nKOc=";

  meta = with lib; {
    description = "CLI tool for formatting SQL";
    homepage = "https://github.com/nrempel/sleek";
    license = licenses.mit;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "sleek";
  };
}
