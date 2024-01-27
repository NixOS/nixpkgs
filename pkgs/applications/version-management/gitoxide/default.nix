{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, stdenv
, libiconv
, Security
, SystemConfiguration
, curl
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "gitoxide";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "gitoxide";
    rev = "v${version}";
    hash = "sha256-mqPaSUBb10LIo95GgqAocD9kALzcSlJyQaimb6xfMLs=";
  };

  cargoHash = "sha256-JOl/hhyuc6vqeK6/oXXMB3fGRapBsuOTaUG+BQ9QSnk=";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ curl ] ++ (if stdenv.isDarwin
    then [ libiconv Security SystemConfiguration ]
    else [ openssl ]);

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "A command-line application for interacting with git repositories";
    homepage = "https://github.com/Byron/gitoxide";
    changelog = "https://github.com/Byron/gitoxide/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ syberant ];
  };
}
