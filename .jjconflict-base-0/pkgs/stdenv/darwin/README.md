# Darwin stdenv design goals

There are two more goals worth calling out explicitly:

1. The standard environment should build successfully with sandboxing enabled on Darwin. It is
   fine if a package requires a `sandboxProfile` to build, but it should not be necessary to
   disable the sandbox to build the stdenv successfully; and
2. The output should depend weakly on the bootstrap tools. Historically, Darwin required updating
   the bootstrap tools prior to updating the version of LLVM used in the standard environment.
   By not depending on a specific version, the LLVM used on Darwin can be updated simply by
   bumping the definition of llvmPackages in `all-packages.nix`.

# Updating the stdenv

There are effectively two steps when updating the standard environment:

1. Update the definition of llvmPackages in `all-packages.nix` for Darwin to match the value of
   llvmPackages.latest in `all-packages.nix`. Timing-wise, this done currently using the spring
   release of LLVM and once llvmPackages.latest has been updated to match. If the LLVM project
   has announced a release schedule of patch updates, wait until those are in nixpkgs. Otherwise,
   the LLVM updates will have to go through staging instead of being merged into master; and
2. Fix the resulting breakage. Most things break due to additional warnings being turned into
   errors or additional strictness applied by LLVM. Fixes may come in the form of disabling those
   new warnings or by fixing the actual source (e.g., with a patch or update upstream). If the
   fix is trivial (e.g., adding a missing int to an implicit declaration), it is better to fix
   the problem instead of silencing the warning.
