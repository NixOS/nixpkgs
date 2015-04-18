{ stdenv, fetchurl, ocamlPackages, zlib }:

stdenv.mkDerivation rec {
  name = "google-drive-ocamlfuse-0.5.12";
  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1489/${name}.tar.gz";
    sha256 = "0yfzzrv4h7vplw6qjm9viymy51jaqqari012agar96zwa86fsrdr";
  };

  buildInputs = [ zlib ] ++ (with ocamlPackages; [ocaml ocamlfuse findlib gapi_ocaml ocaml_sqlite3 camlidl]);
  configurePhase = "ocaml setup.ml -configure --prefix \"$out\"";
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";

  meta = {
    
  };
}
