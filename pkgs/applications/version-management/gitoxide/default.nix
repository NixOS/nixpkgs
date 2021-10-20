{ lib, stdenv, rustPlatform, cmake, fetchFromGitHub, pkg-config, openssl
, libiconv, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "gitoxide";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "gitoxide";
    rev = "v${version}";
    sha256 = "WH8YiW1X7TkURjncm0OefxrZhnhGHaGLwxRNxe17g/0=";
  };

  cargoSha256 = "eTPJMYl9m81o4PJKfpDs61KmehSvKnY+bgybEodOhAM=";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ libiconv Security SystemConfiguration]
    else [ openssl ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "A command-line application for interacting with git repositories";
    homepage = "https://github.com/Byron/gitoxide";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.syberant ];
  };
}
