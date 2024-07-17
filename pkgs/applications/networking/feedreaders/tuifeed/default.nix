{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuifeed";
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-JG/l6NfN5RqBpz9NVcVY3mP/iE31TXvw+Vjq8N8rNIY=";
  };

  cargoHash = "sha256-QKSNbpVRtSKp2q1jVPYTS8XCMtQAyg3AWvD/6+OjI7Y=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  doCheck = false;

  meta = with lib; {
    description = "A terminal feed reader with a fancy UI";
    mainProgram = "tuifeed";
    homepage = "https://github.com/veeso/tuifeed";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ devhell ];
  };
}
