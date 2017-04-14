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

  # module system
  modules = import ./modules.nix;
  options = import ./options.nix;
  types = import ./types.nix;

  # constants
  licenses = import ./licenses.nix;
  platforms = import ./platforms.nix;
  systems = import ./systems.nix;

  # misc
  debug = import ./debug.nix;
  generators = import ./generators.nix;
  misc = import ./deprecated.nix;

  # domain-specific
  sandbox = import ./sandbox.nix;
  fetchers = import ./fetchers.nix;

  # Eval-time filesystem handling
  filesystem = import ./filesystem.nix;

in
  { inherit trivial
            attrsets lists strings stringsWithDeps
            customisation maintainers meta sources
            modules options types
            licenses platforms systems
            debug generators misc
            sandbox fetchers filesystem;
  }
  # !!! don't include everything at top-level; perhaps only the most
  # commonly used functions.
  // trivial // lists // strings // stringsWithDeps // attrsets // sources
  // options // types // meta // debug // misc // modules
  // systems
  // customisation
