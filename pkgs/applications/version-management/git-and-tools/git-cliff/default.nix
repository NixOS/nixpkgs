{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    sha256 = "sha256-lRONRLTByhMalN9BKilCcQn2c9f4cxOnHJLL0l0jaOs=";
  };

  cargoSha256 = "sha256-1r/k3DQ/vjIjMpOHYCRRosbZ22iAFkuq4EbZUcZoWn0=";

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A highly customizable Changelog Generator that follows Conventional Commit specifications";
    homepage = "https://github.com/orhun/git-cliff";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ siraben ];
  };
}
