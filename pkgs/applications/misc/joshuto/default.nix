{ lib, rustPlatform, fetchFromGitHub, stdenv, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "joshuto";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "kamiyaa";
    repo = pname;
    rev = version;
    sha256 = "sha256-9TGHSGYCzU6uAIO4zZ/6+B4oVPE6SD9Phl4dShylW5o=";
  };

  cargoSha256 = "sha256-g8YYOk2RW4GPdkWlvAxd5KFdV4S1l5yKEzNm9OAc8RI=";

  buildInputs = lib.optional stdenv.isDarwin SystemConfiguration;

  meta = with lib; {
    description = "Ranger-like terminal file manager written in Rust";
    homepage = "https://github.com/kamiyaa/joshuto";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
