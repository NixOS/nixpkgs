/* Library of low-level helper functions for nix expressions.
 *
 * Please implement (mostly) exhaustive unit tests
 * for new functions in `./tests.nix'.
 */
let

  # often used, or depending on very little
  trivial = import ./trivial.nix;
  fixedPoints = import ./fixed-points.nix;

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
  systems = import ./systems;

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
  { inherit trivial fixedPoints
            attrsets lists strings stringsWithDeps
            customisation maintainers meta sources
            modules options types
            licenses systems
            debug generators misc
            sandbox fetchers filesystem;

    # back-compat aliases
    platforms = systems.doubles;
  }
  # !!! don't include everything at top-level; perhaps only the most
  # commonly used functions.
  // trivial // fixedPoints
  // lists // strings // stringsWithDeps // attrsets // sources
  // options // types // meta // debug // misc // modules
  // customisation
