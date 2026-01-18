# buildEnv creates a tree of symlinks to the specified paths.  This is
# a fork of the hardcoded buildEnv in the Nix distribution.

{
  buildPackages,
  stdenvNoCC,
  lib,
  replaceVars,
  writeClosure,
}:

let
  builder = replaceVars ./builder.pl {
    inherit (builtins) storeDir;
  };
in

# Backward compatibility for deprecated custom overrider <env-pkg>.override
# TODO(@ShamrockLee): Warn, throw and remove after tree-wide transition.
lib.makeOverridable (
  lib.extendMkDerivation {
    constructDrv = stdenvNoCC.mkDerivation;

    excludeDrvArgNames = [
      # Override these arguments directly
      "derivationArgs"

      # `meta.outputsToInstall` and `extraOutputsToInstall`
      # does not necessarily include the first element of outputs,
      # while the outPath of the latter will be the string-interpolated rsult.
      # Exclude to prevent unexpected context.
      "paths"
    ];

    extendDrvArgs =
      finalAttrs:
      {
        # The manifest file (if any).  A symlink $out/manifest will be
        # created to it.
        manifest ? "",

        # The paths to symlink.
        paths,

        # Whether to ignore collisions or abort.
        ignoreCollisions ? false,

        # Whether to ignore outputs that are a single file instead of a directory.
        ignoreSingleFileOutputs ? false,

        # Whether to include closures of all input paths.
        includeClosures ? false,

        # If there is a collision, check whether the contents and permissions match
        # and only if not, throw a collision error.
        checkCollisionContents ? true,

        # The paths (relative to each element of `paths') that we want to
        # symlink (e.g., ["/bin"]).  Any file not inside any of the
        # directories in the list is not symlinked.
        pathsToLink ? [ "/" ],

        # The package outputs to include. By default, only the default
        # output is included.
        extraOutputsToInstall ? [ ],

        # Root the result in directory "$out${extraPrefix}", e.g. "/share".
        extraPrefix ? "",

        # Shell commands to run after building the symlink tree.
        postBuild ? "",

        passthru ? { },
        meta ? { },

        # Additional stdenv.mkDerivation arguments
        # such as nativeBuildInputs/buildInputs for postBuild dependencies.
        derivationArgs ? { },

        # Placeholder name arguments.
        name ? null,
        pname ? null,
        version ? null,

        # `stdenv.mkDerivation` args before introducing derivationArgs.
        nativeBuildInputs ? null,
        buildInputs ? null,
      }@args:
      let
        compatArgs =
          lib.optionalAttrs (args ? nativeBuildInputs) {
            inherit nativeBuildInputs;
          }
          // lib.optionalAttrs (args ? buildInputs) {
            inherit buildInputs;
          };

        chosenOutputs = map (drv: {
          paths =
            # First add the usual output(s): respect if user has chosen explicitly,
            # and otherwise use `meta.outputsToInstall`. The attribute is guaranteed
            # to exist in mkDerivation-created cases. The other cases (e.g. runCommand)
            # aren't expected to have multiple outputs.
            (
              if
                (!drv ? outputSpecified || !drv.outputSpecified) && drv.meta.outputsToInstall or null != null
              then
                map (outName: drv.${outName}) drv.meta.outputsToInstall
              else
                [ drv ]
            )
            # Add any extra outputs specified by the caller of `buildEnv`.
            ++ lib.filter (p: p != null) (
              map (outName: drv.${outName} or null) finalAttrs.extraOutputsToInstall
            );
          priority = drv.meta.priority or lib.meta.defaultPriority;
          # Silently use the original `paths` if `passthru.paths` is missing.
        }) finalAttrs.passthru.paths or paths;

        pathsForClosure = lib.pipe chosenOutputs [
          (map (p: p.paths))
          lib.flatten
          (lib.remove null)
        ];
      in
      compatArgs
      // derivationArgs
      // {
        inherit
          extraOutputsToInstall
          manifest
          ignoreCollisions
          checkCollisionContents
          ignoreSingleFileOutputs
          includeClosures
          meta
          pathsToLink
          extraPrefix
          postBuild
          ;
        pathsToLinkJSON = builtins.toJSON pathsToLink;
        pkgs = builtins.toJSON chosenOutputs;
        extraPathsFrom = lib.optionalString finalAttrs.includeClosures (writeClosure pathsForClosure);

        preferLocalBuild = derivationArgs.preferLocalBuild or true;
        allowSubstitutes = derivationArgs.allowSubstitutes or false;
        passAsFile = [
          "buildCommand"
        ]
        # XXX: The size is somewhat arbitrary
        ++ lib.optional (lib.stringLength finalAttrs.pkgs >= 128 * 1024) "pkgs"
        ++ derivationArgs.passAsFile or [ ];

        buildCommand = ''
          ${buildPackages.perl}/bin/perl -w ${builder}
          eval "$postBuild"
        '';

        passthru = {
          # The `paths` attribute is referenced and overridden from passthru
          inherit paths;
        }
        // passthru;
      };

    # Function argument set pattern doesn't have an ellipsis
    inheritFunctionArgs = false;
  }
)
