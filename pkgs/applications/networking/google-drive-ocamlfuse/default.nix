{ lib, buildDunePackage, fetchFromGitHub
, ocaml_extlib, ocamlfuse, gapi_ocaml, ocaml_sqlite3
}:

buildDunePackage rec {
  pname = "google-drive-ocamlfuse";
  version = "0.7.26";

  useDune2 = true;

  minimumOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "google-drive-ocamlfuse";
    rev = "v${version}";
    sha256 = "sha256-8s3DnpdYIVyJj5rtsof3WpLvX9wCrWU47dp4D6c986s=";
  };

  buildInputs = [ ocaml_extlib ocamlfuse gapi_ocaml ocaml_sqlite3 ];

  meta = {
    inherit (src.meta) homepage;
    description = "A FUSE-based file system backed by Google Drive, written in OCaml";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ obadz ];
  };
}
