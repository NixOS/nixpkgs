{ lib, stdenv, rustPlatform, cmake, fetchFromGitHub, pkg-config, openssl
, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gitoxide";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "gitoxide";
    rev = "v${version}";
    sha256 = "12f5qrrfjfqp1aph2nmfi9nyzs1ndvgrb3y53mrszm9kf7fa6pyg";
  };

  cargoSha256 = "0gw19zdxbkgnj1kcyqn1naj1dnhsx10j860m0xgs5z7bbvfg82p6";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ libiconv Security ]
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
