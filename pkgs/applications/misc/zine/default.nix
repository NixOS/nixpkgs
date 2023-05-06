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
  version = "0.14.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ydcrU2nIlu7Jx7S00DZmD2lAwLIFNzfv4zzM4SwJLVc=";
  };

  cargoHash = "sha256-j87mpWuYOx7oQyUIlvqKeQ/LZ2lRxz4hyPC0TsrgX2g=";

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
