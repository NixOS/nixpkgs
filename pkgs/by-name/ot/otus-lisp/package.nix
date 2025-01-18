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

  meta = with lib; {
    description = "Purely functional dialect of Lisp";
    homepage = "https://yuriy-chumak.github.io/ol/";
    license = with licenses; [
      mit
      lgpl3Only
    ]; # dual licensed
    platforms = platforms.unix;
    maintainers = with maintainers; [ nagy ];
    mainProgram = "ol";
  };
})
