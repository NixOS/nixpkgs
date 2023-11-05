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
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "bloznelis";
    repo = "kbt";
    rev = version;
    hash = "sha256-zpWaRQvEaHBMe0bQeB8PTqIlHs8BZaYJK1NcMA/NtVI=";
  };

  cargoHash = "sha256-YqwPVQ2emg4Hm9BAggirIkNB0vdUnNfYGaVwQodfrEM=";

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
