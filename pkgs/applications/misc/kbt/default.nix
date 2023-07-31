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
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "bloznelis";
    repo = "kbt";
    rev = version;
    hash = "sha256-IVKGpifLcpqPD4ZYP+1mY0EokNoQW6qSbxt66w6b81w=";
  };

  cargoHash = "sha256-iPsBYccLQdPvzaV7pRa3ZLFFwJ1lIJoFMWChLkQpyyk=";

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
