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
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "gitoxide";
    rev = "v${version}";
    sha256 = "sha256-L5x27rJ9Y3K886OlTvCXV2LY+6L/f6vokCbgrWPCiHY=";
  };

  cargoHash = "sha256-YEHHu9PJ5aJvWUaTXCNKEaV/Rd8lP6Wub/CFJCBykHU=";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ curl ] ++ (if stdenv.isDarwin
    then [ libiconv Security SystemConfiguration ]
    else [ openssl ]);

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
