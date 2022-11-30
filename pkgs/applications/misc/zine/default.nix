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
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-diG5YgaJt3XHd0yzMofaCamKLm9QACtY2DjtMi7ckSA=";
  };

  cargoSha256 = "sha256-lGNM1cY1rDlAfrQvfXwy+YGVq8oqTGPVVE2oCq+8Z8o=";

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
