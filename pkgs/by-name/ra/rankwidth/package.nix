{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rankwidth";
  version = "0.10";

  src = fetchurl {
    url = "mirror://sourceforge/rankwidth/rw-${finalAttrs.version}.tar.gz";
    hash = "sha256-iajtNkiTrBtwq3ChUuPn2zzzSLtpCYqm27lpY535J9s=";
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
})
