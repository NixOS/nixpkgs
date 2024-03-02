{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "zine";
  version = "0.16.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-pUoMMgZQ+oDs9Yhc1rQuy9cUWiR800DlIe8wxQjnIis=";
  };

  cargoHash = "sha256-dXq8O0jVpr0xxvLTrsLJbiyyOMXXtEz7OMINqDEfG4U=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "A simple and opinionated tool to build your own magazine";
    homepage = "https://github.com/zineland/zine";
    changelog = "https://github.com/zineland/zine/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya figsoda ];
    mainProgram = "zine";
  };
}
