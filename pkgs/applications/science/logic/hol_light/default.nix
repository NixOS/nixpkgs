{ lib, stdenv, runtimeShell, fetchFromGitHub, fetchpatch, ocaml, findlib, num, camlp5, camlp-streams }:

let
  load_num =
    lib.optionalString (num != null) ''
      -I ${num}/lib/ocaml/${ocaml.version}/site-lib/num \
      -I ${num}/lib/ocaml/${ocaml.version}/site-lib/top-num \
      -I ${num}/lib/ocaml/${ocaml.version}/site-lib/stublibs \
    '';

  start_script =
    ''
      #!${runtimeShell}
      cd $out/lib/hol_light
      export OCAMLPATH="''${OCAMLPATH-}''${OCAMLPATH:+:}${camlp5}/lib/ocaml/${ocaml.version}/site-lib/"
      exec ${ocaml}/bin/ocaml \
        -I \`${camlp5}/bin/camlp5 -where\` \
        ${load_num} \
        -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib/ \
        -I ${camlp-streams}/lib/ocaml/${ocaml.version}/site-lib/camlp-streams camlp_streams.cma \
        -init make.ml
    '';
in

lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "hol_light is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation {
  pname = "hol_light";
  version = "unstable-2023-11-03";

  src = fetchFromGitHub {
    owner = "jrh13";
    repo = "hol-light";
    rev = "dcd765c6032f52a0c0bf21fce5da4794a823e880";
    hash = "sha256-k2RBNDo4tc3eobKB84Y2xr0UQJvef0hv6jyFCaDCQFM=";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/ocaml-team/hol-light/-/raw/master/debian/patches/0004-Fix-compilation-with-camlp5-7.11.patch";
      sha256 = "180qmxbrk3vb1ix7j77hcs8vsar91rs11s5mm8ir5352rz7ylicr";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [ ocaml findlib camlp5 ];
  propagatedBuildInputs = [ camlp-streams num ];

  installPhase = ''
    mkdir -p "$out/lib/hol_light" "$out/bin"
    cp -a  . $out/lib/hol_light
    echo "${start_script}" > "$out/bin/hol_light"
    chmod a+x "$out/bin/hol_light"
  '';

  meta = with lib; {
    description = "Interactive theorem prover based on Higher-Order Logic";
    homepage = "http://www.cl.cam.ac.uk/~jrh13/hol-light/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice maggesi vbgl ];
  };
}
