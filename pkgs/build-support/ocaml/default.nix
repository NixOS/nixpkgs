{ stdenv, writeText, ocaml, findlib, ocamlbuild, camlp4 }:

{ name, version, buildInputs ? [],
  createFindlibDestdir ?  true,
  dontStrip ? true,
  minimumSupportedOcamlVersion ? null,
  hasSharedObjects ? false,
  setupHook ? null,
  meta ? {}, ...
}@args:
let
  defaultMeta = {
    platforms = ocaml.meta.platforms or [];
  };
in
  assert minimumSupportedOcamlVersion != null ->
          stdenv.lib.versionOlder minimumSupportedOcamlVersion ocaml.version;

stdenv.mkDerivation (args // {
  name = "ocaml-${name}-${version}";

  buildInputs = [ ocaml findlib ocamlbuild camlp4 ] ++ buildInputs;

  setupHook = if setupHook == null && hasSharedObjects
  then writeText "setupHook.sh" ''
    export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH-}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/${name}/"
    ''
  else setupHook;

  inherit createFindlibDestdir;
  inherit dontStrip;

  meta = defaultMeta // meta;
})
