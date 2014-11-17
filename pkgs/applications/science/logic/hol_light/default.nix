{ stdenv, fetchsvn, writeScript, ocaml, findlib, camlp5 }:

let
  start_script = ''
    #!/bin/sh
    cd "$out/lib/hol_light"
    exec ${ocaml}/bin/ocaml -I \`${camlp5}/bin/camlp5 -where\` -init make.ml
  '';
in

stdenv.mkDerivation rec {
  name     = "hol_light-${version}";
  version  = "205";

  src = fetchsvn {
    url = http://hol-light.googlecode.com/svn/trunk;
    rev = version;
    sha256 = "1qnk3fkfr6f74nd8wsi84s9kg872cw766sa15a2ldlhs9ma76chj";
  };

  buildInputs = [ ocaml findlib camlp5 ];

  installPhase = ''
    mkdir -p "$out/lib/hol_light" "$out/bin"
    cp -a  . $out/lib/hol_light
    echo "${start_script}" > "$out/bin/hol_light"
    chmod a+x "$out/bin/hol_light"
  '';

  meta = with stdenv.lib; {
    description = "Interactive theorem prover based on Higher-Order Logic";
    homepage    = http://www.cl.cam.ac.uk/~jrh13/hol-light/;
    license     = licenses.bsd2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice z77z vbgl ];
  };
}
