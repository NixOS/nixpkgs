{ stdenv, ocaml_oasis, ocaml, findlib, ocamlbuild }:

{ name, version, buildInputs ? [], meta ? { platforms = ocaml.meta.platforms or []; },
  minimumOcamlVersion ? null,
  createFindlibDestdir ? true,
  dontStrip ? true,
  ...
}@args:

 assert minimumOcamlVersion != null ->
          stdenv.lib.versionOlder minimumOcamlVersion ocaml.version;

stdenv.mkDerivation (args // {
  name = "ocaml${ocaml.version}-${name}-${version}";

  buildInputs = [ ocaml findlib ocamlbuild ocaml_oasis ] ++ buildInputs;

  inherit createFindlibDestdir;
  inherit dontStrip;

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
