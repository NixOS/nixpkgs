{ lib, ocaml, buildDunePackage, fetchFromGitHub
, extlib, ocamlfuse, gapi-ocaml, ocaml_sqlite3
, tiny_httpd
, ounit2
}:

buildDunePackage rec {
  pname = "google-drive-ocamlfuse";
  version = "0.7.31";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "google-drive-ocamlfuse";
    rev = "v${version}";
    hash = "sha256-4Fs4e4rXSeumaMDXRqGLpPuFs6DC8dmkywGaBqR5sFA=";
  };

  doCheck = lib.versionOlder ocaml.version "5.0";
  checkInputs = [ ounit2 ];

  buildInputs = [ extlib ocamlfuse gapi-ocaml ocaml_sqlite3 tiny_httpd ];

  meta = {
    inherit (src.meta) homepage;
    description = "A FUSE-based file system backed by Google Drive, written in OCaml";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ obadz ];
    mainProgram = "google-drive-ocamlfuse";
  };
}
