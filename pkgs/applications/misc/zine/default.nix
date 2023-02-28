{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, CoreServices
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "zine";
  version = "0.11.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-iva66tN7pMW0LAvhTbL0Tmsvsdq1+96VciTlaNoVywI=";
  };

  cargoHash = "sha256-xAA11Og5odn8eNbFNKiRUqLG/MLWPw1WSeNR9zGHs0U=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];

  meta = with lib; {
    description = "A simple and opinionated tool to build your own magazine";
    homepage = "https://github.com/zineland/zine";
    changelog = "https://github.com/zineland/zine/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya figsoda ];
  };
}
