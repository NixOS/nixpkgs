{
  lib,
  runCommandCC,
  makeBinaryWrapper,
  frama-c,
  why3,
  ocamlPackages,
}:

{
  plugins ? [ ],
  provers ? [ ],
}:

let
  why3WithProvers = why3.withProvers provers;

  duneDirLocations =
    let
      mkLocations =
        p:
        let
          loc = lib.getOutput "dev" p + "/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/frama-c";
        in
        "frama-c:lib:" + loc + ":frama-c:libexec:" + loc;
    in
    lib.concatStringsSep ":" (map mkLocations plugins);

  ocamlPath =
    lib.makeSearchPathOutput "dev" "lib/ocaml/${ocamlPackages.ocaml.version}/site-lib"
      plugins;
in
runCommandCC "${frama-c.name}-with-plugins"
  {
    nativeBuildInputs = [ makeBinaryWrapper ];
    buildInputs = [
      frama-c
      why3WithProvers
    ]
    ++ plugins
    ++ provers;
  }
  ''
    mkdir -p "$out/bin"
    makeWrapper ${frama-c}/bin/frama-c $out/bin/frama-c \
      --set WHY3CONFIG ${why3WithProvers}/share/why3/why3.conf \
      --prefix DUNE_DIR_LOCATIONS : ${duneDirLocations} \
      --prefix OCAMLPATH : ${ocamlPath}
  ''
