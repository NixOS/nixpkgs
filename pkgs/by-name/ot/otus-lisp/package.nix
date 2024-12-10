{
  lib,
  stdenv,
  fetchFromGitHub,
  xxd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "otus-lisp";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "yuriy-chumak";
    repo = "ol";
    rev = finalAttrs.version;
    hash = "sha256-xwn2cvtw3co7MJ4J0FraEtZhKWVaaaoJYMrohyFF+us=";
  };

  nativeBuildInputs = [ xxd ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "A purely functional dialect of Lisp";
    homepage = "https://yuriy-chumak.github.io/ol/";
    license = with lib.licenses; [
      mit
      lgpl3Only
    ]; # dual licensed
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nagy ];
    mainProgram = "ol";
  };
})
