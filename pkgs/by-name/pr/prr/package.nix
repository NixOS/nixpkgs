{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, prr
, testers
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

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  nativeBuildInputs = [ pkg-config ];

  cargoHash = "sha256-HDNJ17SB9XdqDAAmEBJz/P52/QJcuV6sVsgxBVWKIRg=";

  passthru.tests.version = testers.testVersion {
    package = prr;
  };

  meta = with lib; {
    description = "Mailing-list style code reviews for GitHub";
    homepage = "https://github.com/danobi/prr";
    changelog = "https://github.com/danobi/${pname}/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ christoph-heiss ];
    mainProgram = "prr";
    platforms = platforms.all;
  };
}
