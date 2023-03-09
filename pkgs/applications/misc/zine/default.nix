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
  version = "0.12.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ioWgEl+bMaEDjtEQq/4vURS6Q/V9+r72NTWstyHm4mI=";
  };

  cargoHash = "sha256-2BeImBebeO4kLXmBrGjPmAjbrsLUaS2y52KSazVITb0=";

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
