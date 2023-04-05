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
  version = "0.13.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-N+0FEZ8TUbMs9cwPmURr39wRA+m7B4UbUOkpNmF1p9A=";
  };

  cargoHash = "sha256-2Mc1hrVJ3a1tE/Jo6MYjCfd03889raVTyLBzhCQi8ck=";

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
