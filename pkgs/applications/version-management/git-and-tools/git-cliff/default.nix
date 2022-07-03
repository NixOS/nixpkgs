{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    sha256 = "sha256-wVHL2+didmiN7UlEeIuSr+8LhkFKCOD3of4rKVg1i1o=";
  };

  cargoSha256 = "sha256-5jhloUnaGXXDu2LCO86SMJo8ETIxLAivv3hx9gEqtJ4=";

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
