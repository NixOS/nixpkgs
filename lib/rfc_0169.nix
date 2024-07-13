{ lib }:
let
  inherit (lib) functionArgs isAttrs getAttr hasAttr mapAttrsToList warn;

  BACKWARD = builtins.fromJSON (builtins.readFile ./rfc0169.json);
  FORWARD = builtins.listToAttrs (builtins.concatLists (mapAttrsToList (n: map (x: { name = x; value = n; })) BACKWARD));

  # Since we don't know what was the original deprecated name used by the
  # package (if any, really), we have to extend original signature with all
  # known deprecated names.
  #
  # Which means that if before it had "alsaSupport", now override can also be
  # called with "withAlsa". And let's not bring what will happen if somebody
  # provides both. Goal is to keep old code working, not preventing user from
  # defying warnings and doing something stupid.
  mkExtraArgs = name: value:
    if hasAttr name BACKWARD
    then map (n: { name = n; value = value; }) (getAttr name BACKWARD)
    else [];
  renamePair = name: value:
    let renamed = lib.getAttr name FORWARD;
        warning = "Feature parameter '" + name + "' is deprecated in favor of '" + renamed + "'.";
    in if hasAttr name FORWARD && hasAttr (getAttr name FORWARD) BACKWARD
    then warn warning { name = renamed; inherit value; }
    else { inherit name value; };
in {
  rfc0169Renamed = functor:
    let oldArgs = functionArgs functor;
        patch = builtins.listToAttrs (builtins.concatLists (mapAttrsToList mkExtraArgs oldArgs));
    in if patch == {}
       then functor # nothing to do.
       else args': functor (if isAttrs args' then builtins.listToAttrs (mapAttrsToList renamePair args') else args');
}



