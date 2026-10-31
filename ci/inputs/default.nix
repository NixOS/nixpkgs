# This file provides access to the CI-locked flake inputs, without evaluating the flake.
# Instead, it directly imports the JSON lockfile and returns the root node's inputs.
import ./read-inputs.nix ../flake.lock
