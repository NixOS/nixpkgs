/**
  `mkPackage` layer for building NPM packages.
*/
{
  lib,
  stdenv,
  fetchNpmDeps,
  buildPackages,
  nodejs,
  cctools,
}:

let
  # The fetcher needs the unpack related attributes
  fetchInherited = {
    src = null;
    srcs = null;
    sourceRoot = null;
    prePatch = null;
    patches = null;
    postPatch = null;
    patchFlags = null;
  };
in
this: old:
let
  inherit (this) deps name version;
in
{
  deps = {
    inherit (deps.nodejs) fetchNpmDeps;
    npmHooks = buildPackages.npmHooks.override {
      inherit (deps) nodejs;
    };
    inherit (deps.npmHooks) npmConfigHook npmBuildHook npmInstallHook;
  } // old.deps;
  /**
    Arguments for fetchNpmDeps
  */
  npmFetch =
    {
      name = "${name}-${version}-npm-deps";
      hash = throw "Please specify npmFetch.hash in the package definition of ${name}";
      forceEmptyCache = false;
      forceGitDeps = false;
      patchFlags = "";
      postPatch = "";
      prePatch = "";
    }
    // builtins.intersectAttrs fetchInherited this.setup
    // old.npmFetch;
  setup = old.setup or { } // {
    inherit (deps) nodejs;
    npmDeps = fetchNpmDeps this.npmFetch;
    npmPruneFlags = old.setup.npmPruneFlags or this.setup.npmInstallFlags or [ ];
    npmBuildScript = "build";
    nativeBuildInputs =
      old.setup.nativeBuildInputs
      ++ [
        deps.nodejs
        deps.npmConfigHook
        deps.npmBuildHook
        deps.npmInstallHook
        deps.nodejs.python
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];
    buildInputs = old.setup.buildInputs or [ ] ++ [ deps.nodejs ];
    strictDeps = true;
    # Stripping takes way too long with the amount of files required by a typical Node.js project.
    dontStrip = old.dontStrip or true;
  };
  meta = (old.meta or { }) // {
    platforms = old.meta.platforms or deps.nodejs.meta.platforms;
  };
}
