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
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "gitoxide";
    rev = "v${version}";
    hash = "sha256-7iJx7kE606jeaokROmOSoh0egCQUgYwvg8BAA3y1BGs=";
  };

  cargoHash = "sha256-zChqIA/KuS1aBs/g1tlymGvvJeljKMMCODijPhQYy40=";

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
