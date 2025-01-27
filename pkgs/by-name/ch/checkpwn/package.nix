{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "checkpwn";
  version = "0.5.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-M0Jb+8rKn4KVuumNSsM6JEbSOoBOFy9mmXiCnUnDgak=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8ALu1Ij4o2fdsRWhlWu6rOIfHZjIIC+fHJ07XIbH66s=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # requires internet access
  checkFlags = [
    "--skip=test_cli_"
  ];

  meta = with lib; {
    description = "Check Have I Been Pwned and see if it's time for you to change passwords";
    homepage = "https://github.com/brycx/checkpwn";
    changelog = "https://github.com/brycx/checkpwn/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "checkpwn";
  };
}
