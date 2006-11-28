# buildEnv creates a tree of symlinks to the specified paths.  This is
# a fork of the buildEnv in the Nix distribution.  Most changes should
# eventually be merged back into the Nix distribution.

{stdenv, perl}:

{ name

, # The manifest file (if any).  A symlink $out/manifest will be
  # created to it.
  manifest ? ""
  
, # The paths to symlink.
  paths
  
, # Whether to ignore collisions or abort.
  ignoreCollisions ? false

, # The paths (relative to each element of `paths') that we want to
  # symlink (e.g., ["/bin"]).  Any file not inside any of the
  # directories in the list is not symlinked.
  pathsToLink ? ["/"]
}:

stdenv.mkDerivation {
  inherit name manifest paths ignoreCollisions pathsToLink;
  realBuilder = perl + "/bin/perl";
  args = ["-w" ./builder.pl];
}
