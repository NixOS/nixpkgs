{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "graphs";
  version = "20210214";

  src = fetchurl {
    url = "mirror://sageupstream/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ByN8DZhTYRUFw4n9e7klAMh0P1YxurtND0Xf2DMvN0E=";
  };

  installPhase = ''
    mkdir -p "$out/share/graphs"
    cp * "$out/share/graphs/"
  '';

<<<<<<< HEAD
  meta = {
    description = "Database of graphs";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    teams = [ lib.teams.sage ];
=======
  meta = with lib; {
    description = "Database of graphs";
    license = licenses.gpl2;
    platforms = platforms.all;
    teams = [ teams.sage ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
