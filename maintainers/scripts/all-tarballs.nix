/* Helper expression for copy-tarballs. This returns (nearly) all
   tarballs used the free packages in Nixpkgs.

   Typical usage:

   $ copy-tarballs.pl --expr 'import <nixpkgs/maintainers/scripts/all-tarballs.nix>'
*/

removeAttrs (import ../../pkgs/top-level/release.nix
  { # Don't apply ‘hydraJob’ to jobs, because then we can't get to the
    # dependency graph.
    scrubJobs = false;
    # No need to evaluate on i686.
    supportedSystems = [ "x86_64-linux" ];
  })
  [ # Remove jobs whose evaluation depends on a writable Nix store.
    "tarball" "unstable" "darwin-tested"
  ]
