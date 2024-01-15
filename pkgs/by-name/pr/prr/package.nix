{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, openssl
, pkg-config
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "prr";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "danobi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aEugpAa1W7iBMQDojs38mYH8xZ/VMd47Bv3toFQhTSs=";
  };

  cargoHash = "sha256-+CrBsQFOfw8vCafk66Wmatcf2t5gu4gEXAKjxvvPgEg=";

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "A tool that brings mailing list style code reviews to Github PRs";
    homepage = "https://github.com/danobi/prr";
    license = licenses.gpl2Only;
    mainProgram = "prr";
    maintainers = with maintainers; [ evalexpr ];
  };
}

