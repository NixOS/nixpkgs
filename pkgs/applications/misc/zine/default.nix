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
  version = "0.8.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-mcYBaNmfpXDMhZuDxZ8WgwRb0CM3WjATrMH5YcU2Dxo=";
  };

  cargoSha256 = "sha256-Xfy7RRQairzfhVmh2E5ny07/9jACDdTqU2aj4IT1rkE=";

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
