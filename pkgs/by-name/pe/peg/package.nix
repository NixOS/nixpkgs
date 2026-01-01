{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "peg";
  version = "0.1.20";

  src = fetchurl {
    url = "${meta.homepage}/${pname}-${version}.tar.gz";
    sha256 = "sha256-uLcXvJOll2ijXWUlZ5pODOlOa/ZvkrrPKXnGR0VytFo=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "strip" '$(STRIP)'
  '';

  preBuild = "makeFlagsArray+=( PREFIX=$out )";

<<<<<<< HEAD
  meta = {
    homepage = "http://piumarta.com/software/peg/";
    description = "Tools for generating recursive-descent parsers: programs that perform pattern matching on text";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "http://piumarta.com/software/peg/";
    description = "Tools for generating recursive-descent parsers: programs that perform pattern matching on text";
    platforms = platforms.all;
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
