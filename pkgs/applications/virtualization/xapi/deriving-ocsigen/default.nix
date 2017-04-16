{stdenv, fetchurl, ocaml, camlp4, findlib}:

stdenv.mkDerivation {
  name = "deriving-ocsigen-0.3c";
  version = "0.3c";

  src = fetchurl {
    url = "http://ocsigen.org/download/deriving-ocsigen-0.3c.tar.gz";
    sha256 = "1iwlp8f5wgm9caklfm032rp3cbn1zdv21cy9cp6gybkggdj7wvpb";
  };

  buildInputs = [ ocaml camlp4 findlib ];

  configurePhase = "true";

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make install
    '';

  meta = {
    homepage = http://ocsigen.org;
    description = "Extension to OCaml for deriving functions from type declarations";
    license = stdenv.lib.licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
