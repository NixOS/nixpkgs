{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-d2";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "danieleades";
    repo = "mdbook-d2";
    rev = "v${version}";
    hash = "sha256-5/vChjSYMlCcieA10jncoXZw9Gpeol+Am7mUo78Zqho=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-MxeSgSwBOQ5Eb/2mPtacNNX8MBSToon31egrbfxZjZg=";
  doCheck = false;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "D2 diagram generator plugin for MdBook";
    mainProgram = "mdbook-d2";
    homepage = "https://github.com/danieleades/mdbook-d2";
    changelog = "https://github.com/danieleades/mdbook-d2/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao matthiasbeyer ];
  };
}
