{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, darwin
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "kbt";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bloznelis";
    repo = "kbt";
    rev = version;
    hash = "sha256-dC/o5VzdhoggEgY2LvdapT4CuSdz2iI+zbv3RZD/8XU=";
  };

  cargoHash = "sha256-UVTUcc8OeGdCRGFt9FV1rQuOsVWmh2KEDpu1jSC0XHM=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ] ++ lib.optionals stdenv.isLinux [
    xorg.libX11
  ];

  meta = with lib; {
    description = "Keyboard tester in terminal";
    homepage = "https://github.com/bloznelis/kbt";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
