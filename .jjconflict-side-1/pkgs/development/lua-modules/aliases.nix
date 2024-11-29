
lib: self: super:

### Deprecated aliases - for backward compatibility
###
### !!! NOTE !!!
### Use `./remove-attr.py [attrname]` in this directory to remove your alias
### from the `luaPackages` set without regenerating the entire file.

let
  inherit (lib) dontDistribute hasAttr isDerivation mapAttrs;

  # Removing recurseForDerivation prevents derivations of aliased attribute
  # set to appear while listing all the packages available.
  removeRecurseForDerivations = alias:
    if alias.recurseForDerivations or false
    then removeAttrs alias ["recurseForDerivations"]
    else alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias:
    if isDerivation alias then
      dontDistribute alias
    else alias;

  # Make sure that we are not shadowing something from node-packages.nix.
  checkInPkgs = n: alias:
    if hasAttr n super
    then throw "Alias ${n} is still in generated.nix"
    else alias;

  mapAliases = aliases:
    mapAttrs (n: alias:
      removeDistribute
        (removeRecurseForDerivations
          (checkInPkgs n alias)))
      aliases;
in

mapAliases {
  lpty = throw "lpy was removed because broken and unmaintained "; # added 2023-10-14
  cyrussasl = throw "cyrussasl was removed because broken and unmaintained "; # added 2023-10-18
  nlua-nvim = throw "nlua-nvim was removed, use neodev-nvim instead"; # added 2023-12-16
  nvim-client = throw "nvim-client was removed because it is now part of neovim"; # added 2023-12-17
  toml = throw "toml was removed because broken. You can use toml-edit instead"; # added 2024-06-25
}
