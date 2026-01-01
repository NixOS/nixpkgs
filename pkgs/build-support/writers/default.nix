<<<<<<< HEAD
{ callPackages }:

# If you are reading this, you can test these writers by running: nix-build . -A tests.writers
let
=======
{
  config,
  lib,
  callPackages,
}:

# If you are reading this, you can test these writers by running: nix-build . -A tests.writers
let
  aliases = if config.allowAliases then (import ./aliases.nix lib) else prev: { };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # Writers for JSON-like data structures
  dataWriters = callPackages ./data.nix { };

  # Writers for scripts
  scriptWriters = callPackages ./scripts.nix { };

  writers = scriptWriters // dataWriters;
in
<<<<<<< HEAD
writers
=======
writers // (aliases writers)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
