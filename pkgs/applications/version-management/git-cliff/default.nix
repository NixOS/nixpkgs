{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    hash = "sha256-e7DeGcavBgjnH2QY/nqRThYHKzhmbNxYPoOmMF+0I3s=";
  };

  cargoHash = "sha256-MaSqQD3SRuqiOj5hTHAMyTDj2xgboA5QIZEH7BAxjF4=";

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [
    Security SystemConfiguration
  ];

  meta = with lib; {
    description = "A highly customizable Changelog Generator that follows Conventional Commit specifications";
    homepage = "https://github.com/orhun/git-cliff";
    changelog = "https://github.com/orhun/git-cliff/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ siraben ];
    mainProgram = "git-cliff";
  };
}
