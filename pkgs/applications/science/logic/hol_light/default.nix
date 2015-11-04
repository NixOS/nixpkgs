{ stdenv, fetchFromGitHub, writeScript, ocaml, camlp5 }:

let
  start_script = ''
    #!/bin/sh
    cd "$out/lib/hol_light"
    exec ${ocaml}/bin/ocaml -I \`${camlp5}/bin/camlp5 -where\` -init make.ml
  '';
in

stdenv.mkDerivation {
  name     = "hol_light-2015-11-02";

  src = fetchFromGitHub {
    owner  = "jrh13";
    repo   = "hol-light";
    rev    = "10265313397476ddff4ce13e7bbb588025e7272c";
    sha256 = "17b6a7vk9fhppl0h366y7pw6a9sknq1a8gxqg67dzqpb47vda1n0";
  };

  buildInputs = [ ocaml camlp5 ];

  patches = [ ./Makefile.patch ];

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
