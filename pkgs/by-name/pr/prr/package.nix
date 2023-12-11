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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "danobi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mPFnMoYlOU0oJcasrCEHO+Ze1YuwJ0ap7+p2Fs75pcY=";
  };

  cargoHash = "sha256-HDNJ17SB9XdqDAAmEBJz/P52/QJcuV6sVsgxBVWKIRg=";

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

