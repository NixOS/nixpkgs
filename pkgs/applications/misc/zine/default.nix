{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
<<<<<<< HEAD
, darwin
=======
, CoreServices
, Security
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "zine";
<<<<<<< HEAD
  version = "0.16.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-pUoMMgZQ+oDs9Yhc1rQuy9cUWiR800DlIe8wxQjnIis=";
  };

  cargoHash = "sha256-dXq8O0jVpr0xxvLTrsLJbiyyOMXXtEz7OMINqDEfG4U=";
=======
  version = "0.15.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-81aCSIsgi7R4KmH1wvDYJJ1WX1vpT1n20XXSs+pHT54=";
  };

  cargoHash = "sha256-QRxh67WKRUukKGbKQHwWYdDSazN+2g/kf2A3BgePOUM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
  ];

<<<<<<< HEAD
  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];
=======
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A simple and opinionated tool to build your own magazine";
    homepage = "https://github.com/zineland/zine";
    changelog = "https://github.com/zineland/zine/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya figsoda ];
  };
}
