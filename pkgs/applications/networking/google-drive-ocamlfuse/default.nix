{ stdenv, buildDunePackage, fetchFromGitHub
, ocamlfuse, gapi_ocaml, ocaml_sqlite3
}:

buildDunePackage rec {
  pname = "google-drive-ocamlfuse";
  version = "0.7.21";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "google-drive-ocamlfuse";
    rev = "v${version}";
    sha256 = "0by3qnjrr1mbxyl2n99zggx8dxnqlicsq2b2hhhxb2d0k8qn47sw";
  };

  buildInputs = [ ocamlfuse gapi_ocaml ocaml_sqlite3 ];

  meta = {
    homepage = "http://gdfuse.forge.ocamlcore.org/";
    description = "A FUSE-based file system backed by Google Drive, written in OCaml";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ obadz ];
  };
}
