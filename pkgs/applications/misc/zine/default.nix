{ lib
, rustPlatform
, fetchCrate
, pkg-config
, stdenv
, openssl
, CoreServices
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "zine";
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-savwRdIO48gCwqW2Wz/nWZuI1TxW/F0OR9jhNzHF+us=";
  };

  cargoSha256 = "sha256-U+pzT3V4rHiU+Hrax1EUXGQgdjrdfd3G07luaDSam3g=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];

  meta = with lib; {
    description = "A simple and opinionated tool to build your own magazine";
    homepage = "https://github.com/zineland/zine";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya figsoda ];
  };
}
