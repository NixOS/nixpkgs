{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-interactive-rebase-tool";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "MitMaro";
    repo = pname;
    rev = version;
    sha256 = "117zwxyq2vc33nbnfpjbdr5vc2l5ymf6ln1dm5551ha3y3gdq3bf";
  };

  cargoSha256 = "0617jd7q6c1b9555dkdyka9fsyakk794w4icld2b9k2das5qddm3";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  # external_editor::tests::* tests fail
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/MitMaro/git-interactive-rebase-tool";
    description = "Native cross platform full feature terminal based sequence editor for git interactive rebase";
    changelog = "https://github.com/MitMaro/git-interactive-rebase-tool/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ masaeedu SuperSandro2000 zowoq ];
  };
}
