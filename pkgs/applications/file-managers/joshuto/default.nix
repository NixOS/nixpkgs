{ lib, rustPlatform, fetchFromGitHub, stdenv, SystemConfiguration, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "joshuto";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "kamiyaa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sSrXBPZe9R8s+MzWA7cRlaRCyf/4z2qb6DrUCgvKQh8=";
  };

  cargoSha256 = "sha256-e4asmP/wTnX6/xrK6lAgCkRlGRFniveEiL5GRXVzcZg=";

  buildInputs = lib.optionals stdenv.isDarwin [ SystemConfiguration Foundation ];

  meta = with lib; {
    description = "Ranger-like terminal file manager written in Rust";
    homepage = "https://github.com/kamiyaa/joshuto";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ figsoda totoroot ];
  };
}
