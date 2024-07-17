{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    hash = "sha256-JRFd84DR0pLimAslr+LTC2N09sjOuFCXU71hRsEriOs=";
  };

  cargoHash = "sha256-pLbz2z+l8E/R+GffseOacKrjr6ERZf1ETh8tVQjI4TU=";

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
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
