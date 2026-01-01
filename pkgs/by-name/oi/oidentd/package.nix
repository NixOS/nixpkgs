{
  lib,
  stdenv,
  fetchurl,
  bison,
  flex,
}:

stdenv.mkDerivation rec {
  pname = "oidentd";
  version = "3.1.0";
  nativeBuildInputs = [
    bison
    flex
  ];

  src = fetchurl {
    url = "https://files.janikrabe.com/pub/oidentd/releases/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-yyvcnabxNkcIMOiZBjvoOm/pEjrGXFt4W4SG5lprkbc=";
  };

<<<<<<< HEAD
  meta = {
    description = "Configurable Ident protocol server";
    mainProgram = "oidentd";
    homepage = "https://oidentd.janikrabe.com/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Configurable Ident protocol server";
    mainProgram = "oidentd";
    homepage = "https://oidentd.janikrabe.com/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
