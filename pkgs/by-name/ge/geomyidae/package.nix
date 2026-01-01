{
  lib,
  stdenv,
  fetchurl,
  libressl,
}:

stdenv.mkDerivation rec {
  pname = "geomyidae";
  version = "0.99";

  src = fetchurl {
    url = "gopher://bitreich.org/9/scm/geomyidae/tag/geomyidae-v${version}.tar.gz";
    hash = "sha256-QnAUqvyi+b14kIjqnreY6adFl62glRiuX9QiVamR6zw=";
  };

  buildInputs = [ libressl ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

<<<<<<< HEAD
  meta = {
    description = "Gopher daemon for Linux/BSD";
    mainProgram = "geomyidae";
    homepage = "gopher://bitreich.org/1/scm/geomyidae";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.athas ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Gopher daemon for Linux/BSD";
    mainProgram = "geomyidae";
    homepage = "gopher://bitreich.org/1/scm/geomyidae";
    license = licenses.mit;
    maintainers = [ maintainers.athas ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
