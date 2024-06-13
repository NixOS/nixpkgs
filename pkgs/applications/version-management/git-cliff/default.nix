{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    hash = "sha256-iTjfFl/bTvyElCIpTj7dsVu3azUSwNTryyssHdCaODg=";
  };

  cargoHash = "sha256-/Elb/hsk96E7D6TrLgbhD5cQhsXpDigNm5p9FpKGEUQ=";

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [
    Security SystemConfiguration
  ];

  meta = with lib; {
    description = "Highly customizable Changelog Generator that follows Conventional Commit specifications";
    homepage = "https://github.com/orhun/git-cliff";
    changelog = "https://github.com/orhun/git-cliff/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ siraben ];
    mainProgram = "git-cliff";
  };
}
