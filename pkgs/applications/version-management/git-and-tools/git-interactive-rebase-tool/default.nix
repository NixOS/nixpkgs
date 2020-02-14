{ stdenv, ncurses5, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-interactive-rebase-tool";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "MitMaro";
    repo = pname;
    rev = version;
    sha256 = "10z3di2qypgsmg2z7xfs9nlrf9vng5i7l8dvqadv1l4lb9zz7i8q";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "002kr52vlpv1rhnxki29xflpmgk6bszrw0dsxcc34kyal0593ajk";

  buildInputs = [ ncurses5 ] ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  checkFlagsArray = [ "--test-threads=1" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/MitMaro/git-interactive-rebase-tool";
    description = "Native cross platform full feature terminal based sequence editor for git interactive rebase";
    changelog = "https://github.com/MitMaro/git-interactive-rebase-tool/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ masaeedu ];
  };
}
