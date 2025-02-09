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
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "bloznelis";
    repo = "kbt";
    rev = version;
    hash = "sha256-G5/Sb/suTUkpR6OGlOawLVGLTthcrp78Y+5mxlndfA4=";
  };

  cargoHash = "sha256-7P93mttZ9W76lpGPKN33cgr4nEaHRlDQWov+TUbDHkM=";

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
