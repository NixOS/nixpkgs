let

  # trivial, often used functions
  trivial = import ./trivial.nix;

  # datatypes
  attrsets = import ./attrsets.nix;
  lists = import ./lists.nix;
  strings = import ./strings.nix;
  stringsWithDeps = import ./strings-with-deps.nix;

  # packaging
  customisation = import ./customisation.nix;
  maintainers = import ./maintainers.nix;
  meta = import ./meta.nix;
  sources = import ./sources.nix;

  # constants
  licenses = import ./licenses.nix;
  platforms = import ./platforms.nix;
  systems = import ./systems.nix;

  # misc
  debug = import ./debug.nix;
  misc = import ./deprecated.nix;

  # domain-specific
  sandbox = import ./sandbox.nix;
  fetchers = import ./fetchers.nix;

  # NixOS lib
  nixos = import ../nixos/lib;

in
  { inherit trivial
            attrsets lists strings stringsWithDeps
            customisation maintainers meta sources
            nixos
            licenses platforms systems
            debug misc
            sandbox fetchers;
  }
  # !!! don't include everything at top-level; perhaps only the most
  # commonly used functions.
  // trivial // lists // strings // stringsWithDeps // attrsets // sources
  // meta // debug // misc
  // systems
  // customisation
