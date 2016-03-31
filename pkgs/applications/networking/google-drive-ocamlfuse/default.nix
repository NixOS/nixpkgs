{ stdenv, fetchurl, ocamlPackages, zlib }:

stdenv.mkDerivation rec {
  name = "google-drive-ocamlfuse-${version}";
  version = "0.5.22";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1587/${name}.tar.gz";
    sha256 = "1hjm6hyva9sl6lddb0372wsy7f76105iaxh976yyzfn3b4ran6ab";
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
