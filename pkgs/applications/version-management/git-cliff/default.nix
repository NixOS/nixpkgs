{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    hash = "sha256-EmpWJWvYxyg6m08Q77kRehtcVSQOm16ZdcmZWncLch4=";
  };

  cargoHash = "sha256-ECTvfS09CglAavj8LJbfpxnaWQtsp4DZb7GMJHIeEAA=";

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "A highly customizable Changelog Generator that follows Conventional Commit specifications";
    homepage = "https://github.com/orhun/git-cliff";
    changelog = "https://github.com/orhun/git-cliff/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ siraben ];
  };
}
