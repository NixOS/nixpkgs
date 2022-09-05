{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    sha256 = "sha256-xmpT4xzajarc/1Iu0GqLthQlh0N9tJ1LdqJXrB4EN9Q=";
  };

  cargoSha256 = "sha256-f4tB37WiHompXjXqdVy+dNEIn5rhNqda8JTSVUOOlcE=";

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
