{
  lib,
  stdenv,
  fetchurl,
  libressl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geomyidae";
  version = "0.99";

  src = fetchurl {
    url = "gopher://bitreich.org/9/scm/geomyidae/tag/geomyidae-v${finalAttrs.version}.tar.gz";
    hash = "sha256-QnAUqvyi+b14kIjqnreY6adFl62glRiuX9QiVamR6zw=";
  };

  buildInputs = [ libressl ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Gopher daemon for Linux/BSD";
    mainProgram = "geomyidae";
    homepage = "gopher://bitreich.org/1/scm/geomyidae";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.athas ];
    platforms = lib.platforms.unix;
  };
})
