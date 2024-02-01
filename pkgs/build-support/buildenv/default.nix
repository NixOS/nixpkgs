# buildEnv creates a tree of symlinks to the specified paths.  This is
# a fork of the hardcoded buildEnv in the Nix distribution.

{ buildPackages, runCommand, lib, substituteAll }:

let
  builder = substituteAll {
    src = ./builder.pl;
    inherit (builtins) storeDir;
  };
in

lib.makeOverridable
({ name

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

# Additional inputs
, nativeBuildInputs ? [] # Handy e.g. if using makeWrapper in `postBuild`.
, buildInputs ? []

, passthru ? {}
, meta ? {}
}:

runCommand name
  rec {
    inherit manifest ignoreCollisions checkCollisionContents passthru
            meta pathsToLink extraPrefix postBuild
            nativeBuildInputs buildInputs;
    pkgs = builtins.toJSON (map (drv: {
      paths =
        if lib.isDerivation drv then
          lib.filter (p: p != null) (
            map (outName: drv.${outName} or null)
                ((lib.outputsFor drv) ++ extraOutputsToInstall)
          )
        # In some places, the outPath is passed as a string instead of
        # the actual derivation in order to avoid all outputs listed in
        # extraOutputsToInstall being added for those derivations.
        else if lib.isString drv then [ drv ]
        else lib.warnIf (drv != null) "buildenv.nix: unexpected value of type ${lib.nixType drv}" [ ];
      priority = drv.meta.priority or 5;
    }) paths);
    preferLocalBuild = true;
    allowSubstitutes = false;
    # XXX: The size is somewhat arbitrary
    passAsFile = if lib.stringLength pkgs >= 128*1024 then [ "pkgs" ] else [ ];
  }
  ''
    ${buildPackages.perl}/bin/perl -w ${builder}
    eval "$postBuild"
  '')
