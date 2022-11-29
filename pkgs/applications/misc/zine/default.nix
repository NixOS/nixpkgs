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
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-teLx21vA4b+ft4zZqou4EiTHhh9Foq2Vukmk4z0pWUM=";
  };

  cargoSha256 = "sha256-OaA090pvJ6rc29wcsUTiuV4/VY/oDDEOGo94Ol31OzI=";

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
