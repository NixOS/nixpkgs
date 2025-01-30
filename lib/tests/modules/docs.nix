/*
  A basic documentation generating module.
  Declares and defines a `docs` option, suitable for making assertions about
  the extraction "phase" of documentation generation.
*/
{ lib, options, ... }:

let
  inherit (lib)
    head
    length
    mkOption
    types
    ;

  traceListSeq = l: v: lib.foldl' (a: b: lib.traceSeq b a) v l;

in

{
  options.docs = mkOption {
    type = types.lazyAttrsOf types.raw;
    description = ''
      All options to be rendered, without any visibility filtering applied.
    '';
  };
  config.docs = lib.zipAttrsWith (
    name: values:
    if length values > 1 then
      traceListSeq values abort "Multiple options with the same name: ${name}"
    else
      assert length values == 1;
      head values
  ) (map (opt: { ${opt.name} = opt; }) (lib.optionAttrSetToDocList options));
}
