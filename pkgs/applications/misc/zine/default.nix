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
  version = "0.12.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-54kbSli/cEG8MlbPWC3xauj2VFxru/5haXfHaViUCN8=";
  };

  cargoHash = "sha256-youQoyJURmhPZItvfCSytUBpwRrejRf6EzfvjtgXH5E=";

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
