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
  version = "0.11.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-koN30s+giX4wOp4i5QtTLE/t1ZJ9mP0K0YfY0kTuDJY=";
  };

  cargoHash = "sha256-Re/ooEJCRjQSnz1VSzz4uRWx81yOzChBEeH7gedAHJw=";

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
