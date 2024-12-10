{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  libiconv,
  openssl,
  pkg-config,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "convco";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "convco";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-b05RO6x5hnxG6gepRTK4CDlnLqMdp8hl4KL+InzBH70=";
  };

  cargoHash = "sha256-pdnH/9Tda6PXf70W76mg5vVE2rzOI+M61UR+HMtgXC0=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Security
    ];

  meta = with lib; {
    description = "A Conventional commit cli";
    mainProgram = "convco";
    homepage = "https://github.com/convco/convco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [
      hoverbear
      cafkafk
    ];
  };
}
