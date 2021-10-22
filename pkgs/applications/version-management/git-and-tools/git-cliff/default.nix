{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    sha256 = "sha256-9F15XHyFxcE48/ePwjvB7lLkw9FxoQd49G758nupRuk=";
  };

  cargoSha256 = "sha256-gPf4sGDbZzfzVJy+9k3FSOdJ5b8Xci1LTjIrCmP9bW8=";

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
