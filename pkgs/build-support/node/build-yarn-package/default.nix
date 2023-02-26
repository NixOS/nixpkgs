{ lib, stdenv, fetchYarnDeps, nodeHooks, nodejs }:

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
  # Can be calculated in advance with prefetch-yarn-deps.
, yarnDepsHash ? ""
  # Whether to make the cache writable prior to installing dependencies.
  # Don't set this unless npm tries to write to the cache directory, as it can slow down the build.
, makeCacheWritable ? false
  # The script to run to build the project.
, npmBuildScript ? "build"
  # Flags to pass to all npm commands.
, npmFlags ? [ ]
  # Flags to pass to `npm ci` and `npm prune`.
, npmInstallFlags ? [ ]
  # Flags to pass to `npm run ${npmBuildScript}`.
, npmBuildFlags ? [ ]
  # Flags to pass to `npm pack`.
, npmPackFlags ? [ ]
, ...
} @ args:

let
  yarnDeps = fetchYarnDeps {
    name = "${name}-yarn-deps";
    yarnLock = "${src}/yarn.lock";
    hash = yarnDepsHash;
  };

  inherit (nodeHooks.override { inherit nodejs; }) yarnConfigHook npmBuildHook npmInstallHook;
in
stdenv.mkDerivation (args // {
  inherit yarnDeps npmBuildScript;

  nativeBuildInputs = nativeBuildInputs ++ [ nodejs yarnConfigHook npmBuildHook npmInstallHook ];
  buildInputs = buildInputs ++ [ nodejs ];

  strictDeps = true;

  # Stripping takes way too long with the amount of files required by a typical Node.js project.
  dontStrip = args.dontStrip or true;

  passthru = { inherit yarnDeps; } // (args.passthru or { });

  meta = (args.meta or { }) // { platforms = args.meta.platforms or nodejs.meta.platforms; };
})
