let 

  trivial = import ./trivial.nix;
  lists = import ./lists.nix;
  strings = import ./strings.nix;
  stringsWithDeps = import ./strings-with-deps.nix;
  attrsets = import ./attrsets.nix;
  sources = import ./sources.nix;
  modules = import ./modules.nix;
  options = import ./options.nix;
  properties = import ./properties.nix;
  types = import ./types.nix;
  meta = import ./meta.nix;
  debug = import ./debug.nix;
  misc = import ./misc.nix;
  maintainers = import ./maintainers.nix;
  platforms = import ./platforms.nix;
  systems = import ./systems.nix;
  customisation = import ./customisation.nix;
  licenses = import ./licenses.nix;

in
  { inherit trivial lists strings stringsWithDeps attrsets sources options
      properties modules types meta debug maintainers licenses platforms systems;
    # Pull in some builtins not included elsewhere.
    inherit (builtins) pathExists readFile;
  }
  # !!! don't include everything at top-level; perhaps only the most
  # commonly used functions.
  // trivial // lists // strings // stringsWithDeps // attrsets // sources
  // properties // options // types // meta // debug // misc // modules
  // systems
  // customisation
