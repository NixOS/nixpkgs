# buildEnv creates a tree of symlinks to the specified paths.  This is
# a fork of the buildEnv in the Nix distribution.  Most changes should
# eventually be merged back into the Nix distribution.

{ perl, runCommand, lib }:

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

, # The package outputs to include. By default, only the default
  # output is included.
  outputsToLink ? []

, # Root the result in directory "$out${extraPrefix}", e.g. "/share".
  extraPrefix ? ""

, # Shell commands to run after building the symlink tree.
  postBuild ? ""

, # Additional inputs. Handy e.g. if using makeWrapper in `postBuild`.
  buildInputs ? []

, passthru ? {}
}:

runCommand name
  { inherit manifest ignoreCollisions passthru pathsToLink extraPrefix postBuild buildInputs;
    pkgs = builtins.toJSON (map (drv: {
      paths =
        [ drv ]
        ++ lib.concatMap (outputName: lib.optional (drv.${outputName}.outPath or null != null) drv.${outputName}) outputsToLink;
      priority = drv.meta.priority or 5;
    }) paths);
    preferLocalBuild = true;
  }
  ''
    ${perl}/bin/perl -w ${./builder.pl}
    eval "$postBuild"
  ''
