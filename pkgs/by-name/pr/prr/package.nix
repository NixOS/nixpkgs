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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "danobi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-d7o6EQb3pJ+kHSMwFsKy8D3HgTD6fOCSZZNIn+EjdqU=";
  };

  cargoHash = "sha256-+v6vdQs2Ml+8Q7IY6lXV3Z5x2qlfwG9xr4hm6tTaBuk=";

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

