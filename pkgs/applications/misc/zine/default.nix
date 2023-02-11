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
  version = "0.10.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-hkBQ9WaWJrDhGAt35yueINutc7sAMbgbr8Iw5h0Ey4I=";
  };

  cargoSha256 = "sha256-rY7WHgd5wyx7TUgJamzre8HjeI0BRtaM14V3doCkfVY=";

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
