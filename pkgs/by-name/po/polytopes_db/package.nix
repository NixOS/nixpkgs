{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "polytopes_db";
  version = "20170220";

  src = fetchurl {
    url = "mirror://sageupstream/polytopes_db/polytopes_db-${finalAttrs.version}.tar.bz2";
    sha256 = "1q0cd811ilhax4dsj9y5p7z8prlalqr7k9mzq178c03frbgqny6b";
  };

  installPhase = ''
    mkdir -p "$out/share/reflexive_polytopes"
    cp -R * "$out/share/reflexive_polytopes/"
  '';

  meta = {
    description = "Reflexive polytopes database";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    teams = [ lib.teams.sage ];
  };
})
