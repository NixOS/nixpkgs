<<<<<<< HEAD
{ lib, stdenv, runtimeShell, fetchFromGitHub, fetchpatch, ocaml, findlib, num, camlp5, camlp-streams }:

let
  load_num =
    lib.optionalString (num != null) ''
=======
{ lib, stdenv, runtimeShell, fetchFromGitHub, fetchpatch, ocaml, num, camlp5 }:

let
  load_num =
    if num == null then "" else
    ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      -I ${num}/lib/ocaml/${ocaml.version}/site-lib/num \
      -I ${num}/lib/ocaml/${ocaml.version}/site-lib/top-num \
      -I ${num}/lib/ocaml/${ocaml.version}/site-lib/stublibs \
    '';

  start_script =
    ''
      #!${runtimeShell}
      cd $out/lib/hol_light
      exec ${ocaml}/bin/ocaml \
        -I \`${camlp5}/bin/camlp5 -where\` \
        ${load_num} \
<<<<<<< HEAD
        -I ${camlp-streams}/lib/ocaml/${ocaml.version}/site-lib/camlp-streams camlp_streams.cma
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        -init make.ml
    '';
in

<<<<<<< HEAD
lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "hol_light is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation {
  pname = "hol_light";
  version = "unstable-2023-07-21";
=======
stdenv.mkDerivation {
  pname = "hol_light";
  version = "unstable-2019-10-06";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jrh13";
    repo = "hol-light";
<<<<<<< HEAD
    rev = "29b3e114f5c166584f4fbcfd1e1f9b13a25b7349";
    hash = "sha256-Z5/4dCfLRwLMHBmth3xMdFW1M6NzUT/aPEEwSz1/S2E=";
=======
    rev = "5c91b2ded8a66db571824ecfc18b4536c103b23e";
    sha256 = "0sxsk8z08ba0q5aixdyczcx5l29lb51ba4ip3d2fry7y604kjsx6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/ocaml-team/hol-light/-/raw/master/debian/patches/0004-Fix-compilation-with-camlp5-7.11.patch";
      sha256 = "180qmxbrk3vb1ix7j77hcs8vsar91rs11s5mm8ir5352rz7ylicr";
    })
  ];

  strictDeps = true;

<<<<<<< HEAD
  nativeBuildInputs = [ ocaml findlib camlp5 ];
  propagatedBuildInputs = [ camlp-streams num ];
=======
  nativeBuildInputs = [ ocaml camlp5 ];
  propagatedBuildInputs = [ num ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
