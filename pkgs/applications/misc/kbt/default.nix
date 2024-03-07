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
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "bloznelis";
    repo = "kbt";
    rev = version;
    hash = "sha256-ROCZDa5eyGF9yE+zdZ4snzdz8+jk+H6ZnqsnCe8JtJw=";
  };

  cargoHash = "sha256-6zD9WRPWEt0ubppaMRTOusy0zm3z6SGB/5/kMxcJ/Ag=";

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
