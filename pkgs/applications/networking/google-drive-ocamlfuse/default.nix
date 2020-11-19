{ lib, buildDunePackage, fetchFromGitHub
, ocaml_extlib, ocamlfuse, gapi_ocaml, ocaml_sqlite3
}:

buildDunePackage rec {
  pname = "google-drive-ocamlfuse";
  version = "0.7.22";

  useDune2 = true;

  minimumOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "google-drive-ocamlfuse";
    rev = "v${version}";
    sha256 = "027j1r2iy8vnbqs8bv893f0909yk5312ki5p3zh2pdz6s865h750";
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
