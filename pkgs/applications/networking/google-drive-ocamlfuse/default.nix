{ lib, ocaml, buildDunePackage, fetchFromGitHub
, extlib, ocamlfuse, gapi-ocaml, ocaml_sqlite3
, tiny_httpd
, ounit2
}:

buildDunePackage rec {
  pname = "google-drive-ocamlfuse";
  version = "0.7.32";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "google-drive-ocamlfuse";
    rev = "v${version}";
    hash = "sha256-AWr1tcium70rXFKMTv6xcWxndOJua3UXG8Q04TN1Siw=";
  };

  doCheck = lib.versionOlder ocaml.version "5.0";
  checkInputs = [ ounit2 ];

  buildInputs = [ extlib ocamlfuse gapi-ocaml ocaml_sqlite3 tiny_httpd ];

  meta = {
    inherit (src.meta) homepage;
    description = "FUSE-based file system backed by Google Drive, written in OCaml";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ obadz ];
    mainProgram = "google-drive-ocamlfuse";
  };
}
