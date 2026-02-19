{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graphs";
  version = "20210214";

  src = fetchurl {
    url = "mirror://sageupstream/graphs/graphs-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-ByN8DZhTYRUFw4n9e7klAMh0P1YxurtND0Xf2DMvN0E=";
  };

  installPhase = ''
    mkdir -p "$out/share/graphs"
    cp * "$out/share/graphs/"
  '';

  meta = {
    description = "Database of graphs";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    teams = [ lib.teams.sage ];
  };
})
