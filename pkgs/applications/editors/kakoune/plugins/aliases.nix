# Deprecated aliases - for backward compatibility

lib: overridden:

with overridden;

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
  # all-packages.nix.
  checkInPkgs =
    n: alias:
    if builtins.hasAttr n overridden then throw "Alias ${n} is still in kakounePlugins" else alias;

  mapAliases =
    aliases:
    lib.mapAttrs (
      n: alias: removeDistribute (removeRecurseForDerivations (checkInPkgs n alias))
    ) aliases;

  deprecations = lib.mapAttrs (
    old: info: throw "${old} was renamed to ${info.new} on ${info.date}. Please update to ${info.new}."
  ) (lib.importJSON ./deprecated.json);

in
mapAliases (
  {
    kak-auto-pairs = auto-pairs-kak; # backwards compat, added 2021-01-04
    kak-buffers = kakoune-buffers; # backwards compat, added 2021-01-04
    kak-byline = byline-kak; # backwards compat, added 2023-10-22
    kak-fzf = fzf-kak; # backwards compat, added 2021-01-04
    kak-powerline = powerline-kak; # backwards compat, added 2021-01-04
    kak-prelude = prelude-kak; # backwards compat, added 2021-01-04
    kak-vertical-selection = kakoune-vertical-selection; # backwards compat, added 2021-01-04
  }
  // deprecations
)
