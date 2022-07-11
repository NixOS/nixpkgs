{ lib, buildDunePackage, fetchFromGitHub
, ocaml_extlib, ocamlfuse, gapi-ocaml, ocaml_sqlite3
, tiny_httpd
, ounit
}:

buildDunePackage rec {
  pname = "google-drive-ocamlfuse";
  version = "0.7.28";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "google-drive-ocamlfuse";
    rev = "v${version}";
    sha256 = "sha256:1layxqz5iz6wnvk83579m1im9vzq608h7n1h04znpkan0fls6nad";
  };

  doCheck = true;
  checkInputs = [ ounit ];

  buildInputs = [ ocaml_extlib ocamlfuse gapi-ocaml ocaml_sqlite3 tiny_httpd ];

  meta = {
    inherit (src.meta) homepage;
    description = "A FUSE-based file system backed by Google Drive, written in OCaml";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ obadz ];
  };
}
