# Deprecated aliases - for backward compatibility

lib: overridden:

let
  # Removing recurseForDerivation prevents derivations of aliased attribute
  # set to appear while listing all the packages available.
  removeRecurseForDerivations = alias:
    if alias.recurseForDerivations or false then
      lib.removeAttrs alias ["recurseForDerivations"]
    else alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias:
    if lib.isDerivation alias then
      lib.dontDistribute alias
    else alias;

  # Make sure that we are not shadowing something from
  # all-packages.nix.
  checkInPkgs = n: alias: if builtins.hasAttr n overridden
                          then throw "Alias ${n} is still in kakounePlugins"
                          else alias;

  mapAliases = aliases:
     lib.mapAttrs (n: alias: removeDistribute
                             (removeRecurseForDerivations
                              (checkInPkgs n alias)))
                     aliases;

  deprecations = lib.mapAttrs (old: info:
    throw "${old} was renamed to ${info.new} on ${info.date}. Please update to ${info.new}."
  ) (lib.importJSON ./deprecated.json);

in
mapAliases ({
  kak-auto-pairs         = overridden.auto-pairs-kak; # backwards compat, added 2021-01-04
  kak-buffers            = overridden.kakoune-buffers; # backwards compat, added 2021-01-04
  kak-byline             = overridden.byline-kak; # backwards compat, added 2023-10-22
  kak-fzf                = overridden.fzf-kak; # backwards compat, added 2021-01-04
  kak-powerline          = overridden.powerline-kak; # backwards compat, added 2021-01-04
  kak-prelude            = overridden.prelude-kak; # backwards compat, added 2021-01-04
  kak-vertical-selection = overridden.kakoune-vertical-selection; # backwards compat, added 2021-01-04
} // deprecations)
