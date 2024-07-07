{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rustmission";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "intuis";
    repo = "rustmission";
    rev = "v${version}";
    hash = "sha256-OOewobyfJYnspeXFYzTP7SLrNQRnDl0jv81TJjQAdUE=";
  };

  cargoHash = "sha256-dLddB+YA1uC8CVMVI1aVo1oMufxRupW26hGkb8796Ek=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # There is no tests
  doCheck = false;

  meta = {
    description = "A TUI for the Transmission daemon";
    homepage = "https://github.com/intuis/rustmission";
    changelog = "https://github.com/intuis/rustmission/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "rustmission";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
  };
}
