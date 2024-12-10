{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "bunbun";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "devraza";
    repo = "bunbun";
    rev = "refs/tags/v${version}";
    hash = "sha256-jqokKvJYu/xHJHJVuNlTns3cYPLx1osbRUrCpVTCJZ0=";
  };

  cargoHash = "sha256-dWZ5aNaHyTkEmkn88Dx5nCnGyiBmpJ6p5iYC7xj/mBw=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # Cargo.lock is outdated
  preConfigure = ''
    cargo update --offline
  '';

  meta = with lib; {
    description = "A simple and adorable sysinfo utility written in Rust";
    homepage = "https://github.com/devraza/bunbun";
    changelog = "https://github.com/devraza/bunbun/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
    mainProgram = "bunbun";
  };
}
