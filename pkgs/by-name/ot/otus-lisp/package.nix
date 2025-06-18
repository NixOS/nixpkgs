{
  lib,
  stdenv,
  fetchFromGitHub,
  xxd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "otus-lisp";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "yuriy-chumak";
    repo = "ol";
    rev = finalAttrs.version;
    hash = "sha256-5ixpTTXwJbLM2mJ/nwzjz0aKG/QGVLPScY8EaG7swGU=";
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
