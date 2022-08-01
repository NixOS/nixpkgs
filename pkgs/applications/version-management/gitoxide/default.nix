{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, stdenv
, libiconv
, Security
, SystemConfiguration
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "gitoxide";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "gitoxide";
    rev = "v${version}";
    sha256 = "sha256-NdZ39F6nSuLZNOdoxRs79OR6I3oFASXHzm/hecDyxNI=";
  };

  cargoSha256 = "sha256-6uRLW1KJF0yskEfWm9ERQIDgVnerAhQFbMaxhnEDIOc=";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ libiconv Security SystemConfiguration ]
    else [ openssl ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "A command-line application for interacting with git repositories";
    homepage = "https://github.com/Byron/gitoxide";
    changelog = "https://github.com/Byron/gitoxide/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ syberant ];
  };
}
