{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SUcAhXIPgYGFkUIgSrUJrxwWQvkkmWG/d12hv8+PQI0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Fmt6xlYEk9r1You12pF9Jlmb/eThS9ekPkQZBlMOIaw=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      Security
      SystemConfiguration
    ]
  );

  meta = with lib; {
    description = "RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    changelog = "https://github.com/NLnetLabs/routinator/blob/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
    mainProgram = "routinator";
  };
}
