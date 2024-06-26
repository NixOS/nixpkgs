lib: prev:

let
  # Removing recurseForDerivation prevents derivations of aliased attribute
  # set to appear while listing all the packages available.
  removeRecurseForDerivations =
    alias:
    with lib;
    if alias.recurseForDerivations or false then
      removeAttrs alias [ "recurseForDerivations" ]
    else
      alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias: with lib; if isDerivation alias then dontDistribute alias else alias;

  # Make sure that we are not shadowing something from
  # writers.
  checkInPkgs =
    n: alias: if builtins.hasAttr n prev then throw "Alias ${n} is still in writers" else alias;

  mapAliases =
    aliases:
    lib.mapAttrs (
      n: alias: removeDistribute (removeRecurseForDerivations (checkInPkgs n alias))
    ) aliases;

in
mapAliases ({
  # Cleanup before 22.05, Added 2021-12-11
  writePython2 = "Python 2 is EOL and the use of writers.writePython2 is deprecated.";
  writePython2Bin = "Python 2 is EOL and the use of writers.writePython2Bin is deprecated.";
})
