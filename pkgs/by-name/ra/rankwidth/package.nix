{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "rankwidth";
  version = "0.9";

  src = fetchurl {
    url = "mirror://sageupstream/rw/rw-${version}.tar.gz";
    sha256 = "sha256-weA1Bv4lzfy0KMBR/Fay0q/7Wwb7o/LOdWYxRmvvtEE=";
  };

  configureFlags = [
    "--enable-executable=no" # no igraph dependency
  ];

  # check phase is empty for now (as of version 0.9)
  doCheck = true;

  meta = {
    description = "Calculates rank-width and rank-decompositions";
    license = with lib.licenses; [ gpl2Plus ];
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.unix;
  };
}
