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

, # If there is a collision, check whether the contents and permissions match
  # and only if not, throw a collision error.
  checkCollisionContents ? true

, # The paths (relative to each element of `paths') that we want to
  # symlink (e.g., ["/bin"]).  Any file not inside any of the
  # directories in the list is not symlinked.
  pathsToLink ? ["/"]

, # The package outputs to include. By default, only the default
  # output is included.
  extraOutputsToInstall ? []

, # Root the result in directory "$out${extraPrefix}", e.g. "/share".
  extraPrefix ? ""

, # Shell commands to run after building the symlink tree.
  postBuild ? ""

, # Additional inputs. Handy e.g. if using makeWrapper in `postBuild`.
  buildInputs ? []

, passthru ? {}
, meta ? {}
}:

runCommand name
  rec {
    inherit manifest ignoreCollisions checkCollisionContents passthru
            meta pathsToLink extraPrefix postBuild buildInputs;
    pkgs = builtins.toJSON (map (drv: {
      paths =
        # First add the usual output(s): respect if user has chosen explicitly,
        # and otherwise use `meta.outputsToInstall` (guaranteed to exist by stdenv).
        (if (drv.outputUnspecified or false)
          then map (outName: drv.${outName}) drv.meta.outputsToInstall
          else [ drv ])
        # Add any extra outputs specified by the caller of `buildEnv`.
        ++ lib.filter (p: p!=null)
          (builtins.map (outName: drv.${outName} or null) extraOutputsToInstall);
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
