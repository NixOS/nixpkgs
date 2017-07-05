{ lib }:

urlOrRepo: rev: let
  inherit (lib) removeSuffix splitString last;
  base = last (splitString ":" (baseNameOf (removeSuffix "/" urlOrRepo)));

  matched = builtins.match "(.*).git" base;

  short = builtins.substring 0 7 rev;

  appendShort = if (builtins.match "[a-f0-9]*" rev) != null
    then "-${short}"
    else "";
in "${if matched == null then base else builtins.head matched}${appendShort}"