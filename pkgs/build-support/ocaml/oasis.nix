{ buildOcaml, ocaml_oasis }:

{ buildInputs ? [], ...
}@args:

buildOcaml (args // {
  buildInputs = [ ocaml_oasis ] ++ buildInputs;

  buildPhase = ''
    runHook preBuild
    oasis setup
    ocaml setup.ml -configure
    ocaml setup.ml -build
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    ocaml setup.ml -test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    sed -i s+/usr/local+$out+g setup.ml
    sed -i s+/usr/local+$out+g setup.data
    prefix=$OCAMLFIND_DESTDIR ocaml setup.ml -install
    runHook postInstall
  '';
})
