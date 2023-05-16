<<<<<<< HEAD
{ lib, stdenv, fetchNpmDeps, buildPackages, nodejs }:
=======
{ lib, stdenv, fetchNpmDeps, npmHooks, nodejs }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

{ name ? "${args.pname}-${args.version}"
, src ? null
, srcs ? null
, sourceRoot ? null
, prePatch ? ""
, patches ? [ ]
, postPatch ? ""
, nativeBuildInputs ? [ ]
, buildInputs ? [ ]
  # The output hash of the dependencies for this project.
  # Can be calculated in advance with prefetch-npm-deps.
, npmDepsHash ? ""
  # Whether to force the usage of Git dependencies that have install scripts, but not a lockfile.
  # Use with care.
, forceGitDeps ? false
  # Whether to make the cache writable prior to installing dependencies.
  # Don't set this unless npm tries to write to the cache directory, as it can slow down the build.
, makeCacheWritable ? false
  # The script to run to build the project.
, npmBuildScript ? "build"
  # Flags to pass to all npm commands.
, npmFlags ? [ ]
<<<<<<< HEAD
  # Flags to pass to `npm ci`.
=======
  # Flags to pass to `npm ci` and `npm prune`.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, npmInstallFlags ? [ ]
  # Flags to pass to `npm rebuild`.
, npmRebuildFlags ? [ ]
  # Flags to pass to `npm run ${npmBuildScript}`.
, npmBuildFlags ? [ ]
  # Flags to pass to `npm pack`.
, npmPackFlags ? [ ]
<<<<<<< HEAD
  # Flags to pass to `npm prune`.
, npmPruneFlags ? npmInstallFlags
  # Value for npm `--workspace` flag and directory in which the files to be installed are found.
, npmWorkspace ? null
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ...
} @ args:

let
  npmDeps = fetchNpmDeps {
    inherit forceGitDeps src srcs sourceRoot prePatch patches postPatch;
    name = "${name}-npm-deps";
    hash = npmDepsHash;
  };

<<<<<<< HEAD
  # .override {} negates splicing, so we need to use buildPackages explicitly
  npmHooks = buildPackages.npmHooks.override {
    inherit nodejs;
  };

  inherit (npmHooks) npmConfigHook npmBuildHook npmInstallHook;
=======
  inherit (npmHooks.override { inherit nodejs; }) npmConfigHook npmBuildHook npmInstallHook;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
stdenv.mkDerivation (args // {
  inherit npmDeps npmBuildScript;

  nativeBuildInputs = nativeBuildInputs ++ [ nodejs npmConfigHook npmBuildHook npmInstallHook ];
  buildInputs = buildInputs ++ [ nodejs ];

  strictDeps = true;

  # Stripping takes way too long with the amount of files required by a typical Node.js project.
  dontStrip = args.dontStrip or true;

<<<<<<< HEAD
=======
  passthru = { inherit npmDeps; } // (args.passthru or { });

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = (args.meta or { }) // { platforms = args.meta.platforms or nodejs.meta.platforms; };
})
