{ pkgs, lib, fetchFromGitHub, mariadb-connector-c, ... }:

{
  pname = "gerbil-mysql";
  version = "unstable-2023-09-23";
  git-version = "ecec94c";
  gerbil-package = "clan";
  gerbilInputs = [ ];
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ mariadb-connector-c ];
  version-path = "";
  softwareName = "Gerbil-MySQL";

  pre-src = {
    fun = fetchFromGitHub;
    owner = "mighty-gerbils";
    repo = "gerbil-mysql";
    rev = "ecec94c76d7aa23331b7e02ac7732a7923f100a5";
    sha256 = "01506r0ivgp6cxvwracmg7pwr735ngb7899ga3lxy181lzkp6b2c";
  };

  meta = with lib; {
    description = "MySQL bindings for Gerbil";
    homepage    = "https://github.com/mighty-gerbils/gerbil-mysql";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };

  # "-L${mariadb-connector-c}/lib/mariadb"
}
