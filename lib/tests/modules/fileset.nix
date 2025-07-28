{ config, lib, ... }:

let
  inherit (lib)
    mkOption
    mkIf
    types
    mapAttrs
    length
    ;
  inherit (lib.fileset)
    empty
    unions
    toList
    ;
in

{
  options = {
    fileset = mkOption { type = with types; lazyAttrsOf fileset; };

    ## The following option is only here as a proxy to test `fileset` that does
    ## not work so well with `modules.sh` because it is not JSONable. It exposes
    ## the number of elements in the fileset.
    filesetCardinal = mkOption { default = mapAttrs (_: fs: length (toList fs)) config.fileset; };
  };

  config = {
    fileset.ok1 = empty;
    fileset.ok2 = ./fileset;
    fileset.ok3 = unions [
      empty
      ./fileset
    ];
    # fileset.ok4: see imports below
    fileset.ok5 = mkIf false ./fileset;

    fileset.err1 = 1;
    fileset.err2 = "foo";
    fileset.err3 = "./.";
    fileset.err4 = [ empty ];

  };

  imports = [
    { fileset.ok4 = ./fileset; }
    { fileset.ok4 = empty; }
    { fileset.ok4 = ./fileset; }
  ];
}
