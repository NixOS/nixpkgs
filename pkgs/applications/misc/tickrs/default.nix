{ lib, stdenv, rustPlatform, fetchFromGitHub, perl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.14.8";

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8q/dL1Pv25TkL7PESybgIu+0lR0cr6qrK6ItE/r9pbI=";
  };

  cargoHash = "sha256-fOYxOiVpgflwIz9Z6ePhQKDa7DX4D/ZCnPOwq9vWOSk=";

  nativeBuildInputs = [ perl ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    changelog = "https://github.com/tarkah/tickrs/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
