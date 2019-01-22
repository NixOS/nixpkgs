{ stdenv, fetchFromGitHub, ocaml, num, camlp5 }:

let
  load_num =
    if num == null then "" else
      ''
        -I ${num}/lib/ocaml/${ocaml.version}/site-lib/num \
        -I ${num}/lib/ocaml/${ocaml.version}/site-lib/top-num \
        -I ${num}/lib/ocaml/${ocaml.version}/site-lib/stublibs \
      '';

  start_script =
    ''
      #!${stdenv.shell}
      cd $out/lib/hol_light
      exec ${ocaml}/bin/ocaml \
        -I \`${camlp5}/bin/camlp5 -where\` \
        ${load_num} \
        -init make.ml
    '';
in

stdenv.mkDerivation {
  name     = "hol_light-2018-09-30";

  src = fetchFromGitHub {
    owner  = "jrh13";
    repo   = "hol-light";
    rev    = "27e09dd27834de46e917057710e9d8ded51a4c9f";
    sha256 = "1p0rm08wnc2lsrh3xzhlq3zdhzqcv1lbqnkwx3aybrqhbg1ixc1d";
  };

  buildInputs = [ ocaml camlp5 ];
  propagatedBuildInputs = [ num ];

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
