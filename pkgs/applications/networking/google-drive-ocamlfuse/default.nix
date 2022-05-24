{ lib, buildDunePackage, fetchFromGitHub
, ocaml_extlib, ocamlfuse, gapi_ocaml, ocaml_sqlite3
, ounit
}:

buildDunePackage rec {
  pname = "google-drive-ocamlfuse";
  version = "0.7.27";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "google-drive-ocamlfuse";
    rev = "v${version}";
    sha256 = "sha256:0dnllnzdc1lg742a4rqhwscnhwm4kv0sqq35bmg59fyws08cj2z8";
  };

  doCheck = true;
  checkInputs = [ ounit ];

  buildInputs = [ ocaml_extlib ocamlfuse gapi_ocaml ocaml_sqlite3 ];

  meta = {
    inherit (src.meta) homepage;
    description = "A FUSE-based file system backed by Google Drive, written in OCaml";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ obadz ];
  };
}
