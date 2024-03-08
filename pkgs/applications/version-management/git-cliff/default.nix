{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    hash = "sha256-5NWMpdrOWQcA3cxd5WNtnamnSMuZU3BGEMlRZ8NR+NE=";
  };

  cargoHash = "sha256-kIO3mD4SdQqlZYty8QWOBVvmaXujcEijeRONGYNZSng=";

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
  };
}
