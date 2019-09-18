{ lib }:

with lib;
{


  /*
    Converts the kernel final configuration file into a structured nix config
    Example:
      loadConfig linux.configfile.outPath
    returns
        { IDE = "y"; ... }
   */
  loadConfig = configFilename: let

    lines = filter (x: builtins.typeOf x == "string")
        (builtins.split "\n" (builtins.readFile configFilename));

    parseLine = line:
      let
        # String options have double quotes, e.g. 'CONFIG_NLS_DEFAULT="utf8"' and allow escaping.
        match_freeform = builtins.match ''^CONFIG_([A-Za-z0-9_]+)="(.*)"$'' line;
        match_tristate = builtins.match ''^CONFIG_([A-Za-z0-9_]+)=(.*)$'' line;
        match_unset = builtins.match ''^# CONFIG_([A-Za-z0-9_]+) is not set$'' line;
        match = if (match_freeform != null && (length match_freeform == 2) ) then
          { "${head match_freeform}" = last match_freeform; }
        else if (match_tristate != null && (length match_tristate == 2)) then
          { "${head match_tristate}" = last match_tristate; }
        else if (match_unset != null) then
          { "${head match_unset}" = "n"; }
        else
          {}
        ;

      in
        match;
    in
      builtins.foldl' (prev: line: prev // (parseLine line) ) {} lines ;

  # Keeping these around in case we decide to change this horrible implementation :)
  option = x:
      x // { optional = true; };

  yes      = { tristate    = "y"; };
  no       = { tristate    = "n"; };
  module   = { tristate    = "m"; };
  freeform = x: { freeform = x; };

  /*
    Common patterns/legacy used in common-config/hardened-config.nix
   */
  whenHelpers = version: {
    whenAtLeast = ver: mkIf (versionAtLeast version ver);
    whenOlder   = ver: mkIf (versionOlder version ver);
    # range is (inclusive, exclusive)
    whenBetween = verLow: verHigh: mkIf (versionAtLeast version verLow && versionOlder version verHigh);
  };

}
