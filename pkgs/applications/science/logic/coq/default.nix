{stdenv, fetchurl, ocaml, ncurses}:

stdenv.mkDerivation (rec {

  name = "coq-8.1pl3";
  src = fetchurl {
    url = "http://coq.inria.fr/V8.1pl3/files/coq-8.1pl3.tar.gz";
    sha256 = "7f8f45594adff2625312c5ecb144cb00d39c99201dac309c9286b34d01a36bb6";
  };

  buildInputs = [ocaml ncurses];

  prefixKey = "-prefix ";
  patchPhase = ''
    UNAME=$(type -tp uname)
    MV=$(type -tp mv)
    RM=$(type -tp cp)
    substituteInPlace ./configure --replace "/bin/uname" "$UNAME"
    substituteInPlace Makefile --replace "/bin/mv" "$MV" \
                               --replace "/bin/rm" "$RM"
  '';

})
