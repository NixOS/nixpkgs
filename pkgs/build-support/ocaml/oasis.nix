{ stdenv, ocaml_oasis, ocaml, findlib, ocamlbuild, camlp4 }:

{ name, version, buildInputs ? [], meta ? { platforms = ocaml.meta.platforms or []; },
  minimumOcamlVersion ? null,
  createFindlibDestdir ? true,
  dontStrip ? true,
  hasSharedObjects ? false,
  setupHook ? null,
  ...
}@args:

 assert minimumOcamlVersion != null ->
          stdenv.lib.versionOlder minimumOcamlVersion ocaml.version;

stdenv.mkDerivation (args // {
  name = "ocaml-${name}-${version}";

  buildInputs = [ ocaml findlib ocamlbuild camlp4 ocaml_oasis ] ++ buildInputs;

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

  setupHook = if setupHook == null && hasSharedObjects
              then stdenv.writeText "setupHook.sh" ''
              export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/${name}/"
              ''
              else setupHook;

})
