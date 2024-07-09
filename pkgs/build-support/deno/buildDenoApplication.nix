{
  lib,
  stdenvNoCC,
  fetchDenoDeps,
}@topLevelArgs:
{
  # Name of the package
  name ? "${args.pname}-${args.version}",
  # Use this deno binary
  deno ? topLevelArgs.deno,

  # Name for the vendored dependencies tarball
  denoDepsName ? "${name}-deno-deps",
  # The vendored dependencies. The output structure of that derivation is still tbd
  denoDeps ? (
    fetchDenoDeps {
      inherit
        src
        srcs
        sourceRoot
        prePatch
        patches
        postPatch
        ;
      name = denoDepsName;
      hash = denoDepsHash;
    }
  ),
  # Hash of the vendored dependencies. Leave empty if you dont know it yet
  denoDepsHash ? "",

  # Configuration for finding the main script and the config file 
  # The main script you would run with `deno run`
  script,
  # The deno.json config file. 
  # TODO: Add support for deno.jsonc and allow for projects without deno.json
  denoJson ? "deno.json",
  # Customize the deno lockfile location
  denoLock ? null,
  # TODO: Allow projects with custom vendored dependencies

  # Configuration for how the application should be run
  # Create a temporary directory, where deno can cache some things. Stops deno from whining about not being able to write to the deno directory.
  # Not used if compile is true.
  writableDenoDirectory ? true,
  # Just produce a single binary, instead of a whole directory.
  compile ? false,
  # Add some flags by default, when executing your application. Like `--allow-net` or `-A`
  runtimeFlags ? [ ],

  # Idk if I actually need to specify these explitly
  # Both npm and rust explicity specify src, srcs, and sourceRoot
  src ? null,
  srcs ? null,
  sourceRoot ? null,
  nativeBuildInputs ? [ ],
  passthru ? { },
  patches ? [ ],
  meta ? { },
  prePatch ? "",
  postPatch ? "",
  buildInputs ? [ ],
  preUnpack ? null,
  unpackPhase ? null,
  postUnpack ? null,
  # We want parallel builds by default
  # TODO: idk if deno even supports something like parallel building
  enableParallelBuilding ? false,

  # References used:
  # pkgs/build-support/rust/build-rust-package/default.nix
  # pkgs/build-support/node/build-npm-package/default.nix
  # pkgs/build-support/go/module.nix
  # 
  # Looked at and didnt understand:
  # pkgs/development/compilers/nim/build-nim-package.nix

  # # Go specific things
  # # TODO: Find out if there are any clever ideas here
  # # A function to override the goModules derivation
  # overrideModAttrs ? (_oldAttrs: { }),
  # # path to go.mod and go.sum directory
  # modRoot ? "./",
  # # vendorHash is the SRI hash of the vendored dependencies
  # #
  # # if vendorHash is null, then we won't fetch any dependencies and
  # # rely on the vendor folder within the source.
  # # TODO: We need something like this
  # vendorHash ? throw (
  #   if args' ? vendorSha256 then
  #     "buildGoModule: Expect vendorHash instead of vendorSha256"
  #   else
  #     "buildGoModule: vendorHash is missing"
  # ),
  # # Whether to delete the vendor folder supplied with the source.
  # # TODO: We could do that too, to allow vendored dependencies
  # deleteVendor ? false,
  # # Whether to fetch (go mod download) and proxy the vendor directory.
  # # This is useful if your code depends on c code and go mod tidy does not
  # # include the needed sources to build or if any dependency has case-insensitive
  # # conflicts which will produce platform dependant `vendorHash` checksums.
  # # TODO: Figure out what this does
  # proxyVendor ? false,
  # # We want parallel builds by default
  # # TODO: idk if deno even supports something like parallel building
  # enableParallelBuilding ? true,
  # # Do not enable this without good reason
  # # IE: programs coupled with the compiler
  # allowGoReference ? false,
  # CGO_ENABLED ? go.CGO_ENABLED,
  # # Not needed with buildGoModule
  # # TODO: Figure out what this does
  # goPackagePath ? "",
  # # TODO: I dont think these apply to us. But maybe something similar for deno flags
  # ldflags ? [ ],
  # GOFLAGS ? [ ],
  # # needed for buildFlags{,Array} warning
  # buildFlags ? "",
  # buildFlagsArray ? "",

  # # Node specific things
  # # TODO: Find out if there are any clever ideas here

  # # The output hash of the dependencies for this project.
  # # Can be calculated in advance with prefetch-npm-deps.
  # # TODO: We need something like this
  # npmDepsHash ? "",
  # # Whether to force the usage of Git dependencies that have install scripts, but not a lockfile.
  # # Use with care.
  # # TODO: Is this reproducible
  # forceGitDeps ? false,
  # # Whether to force allow an empty dependency cache.
  # # This can be enabled if there are truly no remote dependencies, but generally an empty cache indicates something is wrong.
  # # TODO: Figure out if what this does
  # forceEmptyCache ? false,
  # # Whether to make the cache writable prior to installing dependencies.
  # # Don't set this unless npm tries to write to the cache directory, as it can slow down the build.
  # # TODO: Probably not the same thing as our build deno dir thing
  # makeCacheWritable ? false,
  # # The script to run to build the project.
  # # TODO: Maybe add support for deno scripts. But I think that is a bad idea
  # npmBuildScript ? "build",
  # # Flags to pass to all npm commands.
  # # TODO: We also need something like this to customize the deno build
  # npmFlags ? [ ],
  # # Flags to pass to `npm ci`.
  # npmInstallFlags ? [ ],
  # # Flags to pass to `npm rebuild`.
  # npmRebuildFlags ? [ ],
  # # Flags to pass to `npm run ${npmBuildScript}`.
  # npmBuildFlags ? [ ],
  # # Flags to pass to `npm pack`.
  # npmPackFlags ? [ ],
  # # Flags to pass to `npm prune`.
  # npmPruneFlags ? npmInstallFlags,
  # # Value for npm `--workspace` flag and directory in which the files to be installed are found.
  # # TODO: Does deno even have workspaces?
  # npmWorkspace ? null,
  # # TODO: Figure out what these hooks do
  # # Custom npmConfigHook
  # npmConfigHook ? null,
  # # Custom npmBuildHook
  # npmBuildHook ? null,
  # # Custom npmInstallHook
  # npmInstallHook ? null,

  # # Rust specific things
  # # TODO: Find out if there are any clever ideas here

  # # TODO: I dont think deno has a way of patching deps. We could however overwrite paths
  # cargoPatches ? [ ],
  # # TODO: Figure out what loglevel is set here
  # logLevel ? "",
  # # TODO: Figure out where these hook
  # cargoUpdateHook ? "",
  # cargoDepsHook ? "",
  # # TODO: Does deno have different build types?
  # buildType ? "release",
  # # TODO: Locking in cargo is done here
  # cargoLock ? null,
  # # TODO: Figure out what the vendor dir does
  # cargoVendorDir ? null,
  # # TODO: ???
  # checkType ? buildType,
  # buildNoDefaultFeatures ? false,
  # checkNoDefaultFeatures ? buildNoDefaultFeatures,
  # # TODO: Does deno provide a way of configuring features?
  # buildFeatures ? [ ],
  # checkFeatures ? buildFeatures,
  # # TODO: Does deno have a way of running tests? Are rust tests enabled by default?
  # useNextest ? false,
  # # TODO: What does auditable mean in this context? Is it reproducibility?
  # # Enable except on aarch64 pkgsStatic, where we use lld for reasons
  # # auditable ?
  # #   !cargo-auditable.meta.broken
  # #   && !(
  # #     stdenv.hostPlatform.isStatic && stdenv.hostPlatform.isAarch64 && !stdenv.hostPlatform.isDarwin
  # #   ),
  # # TODO: Figure out what this does
  # depsExtraArgs ? { },

  # # Toggles whether a custom sysroot is created when the target is a .json file.
  # # TODO: Figure out what this does
  # __internal_dontAddSysroot ? false,

  # # Needed to `pushd`/`popd` into a subdir of a tarball if this subdir
  # # contains a Cargo.toml, but isn't part of a workspace (which is e.g. the
  # # case for `rustfmt`/etc from the `rust-sources).
  # # Otherwise, everything from the tarball would've been built/tested.
  # # Figure out what this does
  # buildAndTestSubdir ? null,
  ...
}@args:
stdenvNoCC.mkDerivation { }
