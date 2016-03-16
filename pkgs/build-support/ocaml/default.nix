{ stdenv, writeText, ocaml, findlib, camlp4 }:

{ name, version, buildInputs ? [],
  createFindlibDestdir ?  true,
  dontStrip ? true,
  minimumSupportedOcamlVersion ? null,
  hasSharedObjects ? false,
  setupHook ? null,
  meta ? {}, ...
}@args:
let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  defaultMeta = {
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
  };
in
  assert minimumSupportedOcamlVersion != null ->
          stdenv.lib.versionOlder minimumSupportedOcamlVersion ocaml_version;

stdenv.mkDerivation (args // {
  name = "ocaml-${name}-${version}";

  buildInputs = [ ocaml findlib camlp4 ] ++ buildInputs;

  setupHook = if setupHook == null && hasSharedObjects
  then writeText "setupHook.sh" ''
    export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml_version}/site-lib/${name}/"
    ''
  else setupHook;

  inherit ocaml_version;
  inherit createFindlibDestdir;
  inherit dontStrip;

  meta = defaultMeta // meta;
})
