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

  cargoSha256 = "051llwk9swq03xdqwyj0hlyv2ywq2f1cnks95nygyy393q7v930x";

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
