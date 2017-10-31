{ stdenv, fetchFromGitHub, zlib
, ocaml, ocamlbuild, ocamlfuse, findlib, gapi_ocaml, ocaml_sqlite3, camlidl }:

stdenv.mkDerivation rec {
  name = "google-drive-ocamlfuse-${version}";
  version = "0.6.21";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "google-drive-ocamlfuse";
    rev = "v${version}";
    sha256 = "14qvhz18pzxdgxk5vcs024ajbkxccfwc9p3z5r6vfkc9mm851v59";
  };

  nativeBuildInputs = [ ocamlbuild ];

  buildInputs = [ zlib ocaml ocamlfuse findlib gapi_ocaml ocaml_sqlite3 camlidl ];

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
