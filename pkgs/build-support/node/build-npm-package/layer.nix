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
    nodejs = nodejs;
    inherit (deps.nodejs) fetchNpmDeps;
    npmHooks = buildPackages.npmHooks.override {
      inherit (deps) nodejs;
    };
    inherit (deps.npmHooks) npmConfigHook npmBuildHook npmInstallHook;
  }
  // old.deps;
  /**
    Arguments for fetchNpmDeps
  */
  npmFetch = {
    name = "${name}-${version}-npm-deps";
    hash = throw "Please specify npmFetch.hash in the package definition of ${name}";
    forceEmptyCache = false;
    forceGitDeps = false;
    patchFlags = "";
    postPatch = "";
    prePatch = "";
  }
  // builtins.intersectAttrs fetchInherited this.stdenvArgs
  // old.npmFetch;
  stdenvArgs = old.stdenvArgs or { } // {
    inherit (deps) nodejs;
    npmDeps = fetchNpmDeps this.npmFetch;
    npmPruneFlags = old.stdenvArgs.npmPruneFlags or this.stdenvArgs.npmInstallFlags or [ ];
    npmBuildScript = "build";
    nativeBuildInputs =
      old.stdenvArgs.nativeBuildInputs or [ ]
      ++ [
        deps.nodejs
        deps.npmConfigHook
        deps.npmBuildHook
        deps.npmInstallHook
        deps.nodejs.python
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];
    buildInputs = old.stdenvArgs.buildInputs or [ ] ++ [ deps.nodejs ];
    strictDeps = true;
    # Stripping takes way too long with the amount of files required by a typical Node.js project.
    dontStrip = old.dontStrip or true;
  };
  meta = (old.meta or { }) // {
    platforms = old.meta.platforms or deps.nodejs.meta.platforms;
  };
  # Mirror `extendDerivation`'s behaviour for the relevant
  # derivation attrs that downstream tools (e.g. `nixpkgs-vet`'s
  # NPV-165 `strictDeps` check) read directly off the package
  # attrset. We don't merge `this.drvAttrs` wholesale because that
  # would force `makeDerivationArgument`-output keys whose
  # conditional structure depends on input *values*, creating a
  # fixpoint cycle whenever `super.<key>` reads back through
  # `old.public` in an `overrideAttrs` chain.
  public = (old.public or { }) // {
    strictDeps = true;
  };
}
