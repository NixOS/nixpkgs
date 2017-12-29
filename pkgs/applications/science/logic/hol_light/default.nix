{ stdenv, fetchFromGitHub, fetchpatch, writeScript, ocaml, camlp5 }:

let
  start_script = ''
    #!/bin/sh
    cd "$out/lib/hol_light"
    exec ${ocaml}/bin/ocaml -I \`${camlp5}/bin/camlp5 -where\` -init make.ml
  '';
in

stdenv.mkDerivation {
  name     = "hol_light-2017-07-06";

  src = fetchFromGitHub {
    owner  = "jrh13";
    repo   = "hol-light";
    rev    = "0ad8cbdb4de08a38dac600f352555e8454499faa";
    sha256 = "0px9hl1b0mkyqv84j0si1zdq4066ffdrhzp27p2iah9l8ynbvpaq";
  };

  buildInputs = [ ocaml camlp5 ];

  patches = [ (fetchpatch {
      url = https://github.com/girving/hol-light/commit/f80524bad61fd6f6facaa42153b2e29d1eab4658.patch;
      sha256 = "1563wp597vakhmsgg8940dpirzzfvvxqp75x3dnx20rvmi2n2xw0";
    })
  ];

  postPatch = "cp pa_j_3.1x_{6,7}.xx.ml";

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
