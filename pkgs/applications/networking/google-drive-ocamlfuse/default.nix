{ stdenv, fetchurl, zlib
, ocaml, ocamlbuild, ocamlfuse, findlib, gapi_ocaml, ocaml_sqlite3, camlidl }:

stdenv.mkDerivation rec {
  name    = "google-drive-ocamlfuse-${version}";
  version = "0.6.17";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1674/${name}.tar.gz";
    sha256 = "1ldja7080pnjaibrbdvfqwakp4mac8yw1lkb95f7lgldmy96lxas";
  };

  buildInputs = [ zlib ocaml ocamlbuild ocamlfuse findlib gapi_ocaml ocaml_sqlite3 camlidl];

  configurePhase = "ocaml setup.ml -configure --prefix \"$out\"";
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";

  meta = {
    homepage = http://gdfuse.forge.ocamlcore.org/;
    description = "A FUSE-based file system backed by Google Drive, written in OCaml";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ obadz ];
  };
}
