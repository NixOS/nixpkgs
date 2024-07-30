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
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "danobi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-siQZ3rDKv2lnn1bmisRsexWwfvmMhK+z4GZGPsrfPgc=";
  };

  cargoHash = "sha256-vCZjgmBYO+I6MZLCOMp50bWEeHwLbZsxSz5gRmBykvI=";

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Tool that brings mailing list style code reviews to Github PRs";
    homepage = "https://github.com/danobi/prr";
    license = licenses.gpl2Only;
    mainProgram = "prr";
    maintainers = with maintainers; [ evalexpr ];
  };
}

