{ stdenv, fetchFromGitHub, ocamlPackages, zlib }:

stdenv.mkDerivation rec {
  name = "google-drive-ocamlfuse-${version}";
  version = "0.5.18";

  src = fetchFromGitHub {
    owner  = "astrada";
    repo   = "google-drive-ocamlfuse";
    rev    = "v${version}";
    sha256 = "0a545zalsqw3jndrvkc0bsn4aab74cf8lwnsw09b5gjm8pm79b9r";
  };

  buildInputs = [ zlib ] ++ (with ocamlPackages; [ocaml ocamlfuse findlib gapi_ocaml ocaml_sqlite3 camlidl]);

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
