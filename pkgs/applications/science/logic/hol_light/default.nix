{
  lib,
  stdenv,
  runtimeShell,
  fetchFromGitHub,
  fetchpatch,
  ocaml,
  findlib,
  num,
  zarith,
  camlp5,
  camlp-streams,
}:

let
  use_zarith = lib.versionAtLeast ocaml.version "4.14";
  load_num =
    if use_zarith then
      ''
        -I ${zarith}/lib/ocaml/${ocaml.version}/site-lib/zarith \
        -I ${zarith}/lib/ocaml/${ocaml.version}/site-lib/stublibs \
      ''
    else
      lib.optionalString (num != null) ''
        -I ${num}/lib/ocaml/${ocaml.version}/site-lib/num \
        -I ${num}/lib/ocaml/${ocaml.version}/site-lib/top-num \
        -I ${num}/lib/ocaml/${ocaml.version}/site-lib/stublibs \
      '';

  start_script = ''
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

stdenv.mkDerivation {
  pname = "hol_light";
  version = "unstable-2024-05-10";

  src = fetchFromGitHub {
    owner = "jrh13";
    repo = "hol-light";
    rev = "d8366986e22555c4e4c8ff49667d646d15c35f14";
    hash = "sha256-dN9X7yQlFof759I5lxxL4DxDe8V3XAhCRaryO9NabY4=";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/ocaml-team/hol-light/-/raw/master/debian/patches/0004-Fix-compilation-with-camlp5-7.11.patch";
      sha256 = "180qmxbrk3vb1ix7j77hcs8vsar91rs11s5mm8ir5352rz7ylicr";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    ocaml
    findlib
    camlp5
  ];
  propagatedBuildInputs = [
    camlp-streams
    (if use_zarith then zarith else num)
  ];

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
    maintainers = with maintainers; [
      thoughtpolice
      maggesi
      vbgl
    ];
  };
}
