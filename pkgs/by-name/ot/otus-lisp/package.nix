{
  lib,
  stdenv,
  fetchFromGitHub,
  xxd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "otus-lisp";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "yuriy-chumak";
    repo = "ol";
    rev = finalAttrs.version;
    hash = "sha256-7QUyfA9aEZ0VJO4Un2jCyXIxl98tsW4/KjW7LWDnMtU=";
  };

  nativeBuildInputs = [ xxd ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Purely functional dialect of Lisp";
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
