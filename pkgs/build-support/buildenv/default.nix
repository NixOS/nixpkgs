# buildEnv creates a tree of symlinks to the specified paths.  This is
# a fork of the buildEnv in the Nix distribution.  Most changes should
# eventually be merged back into the Nix distribution.

{ perl, runCommand }:

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

, # Root the result in directory "$out${extraPrefix}", e.g. "/share".
  extraPrefix ? ""

, # Shell commands to run after building the symlink tree.
  postBuild ? ""

, # Additional inputs. Handy e.g. if using makeWrapper in `postBuild`.
  buildInputs ? []

, passthru ? {}
}:

runCommand name
  rec { inherit manifest ignoreCollisions passthru pathsToLink extraPrefix postBuild buildInputs;
        pkgs = builtins.toJSON (map (drv: {
          paths = [ drv ]; # FIXME: handle multiple outputs
          priority = drv.meta.priority or 5;
        }) paths);
        preferLocalBuild = true;
        # XXX: The size is somewhat arbitrary
        passAsFile = if builtins.stringLength pkgs >= 128*1024 then [ "pkgs" ] else null;
  }
  ''
    ${perl}/bin/perl -w ${./builder.pl}
    eval "$postBuild"
  ''
