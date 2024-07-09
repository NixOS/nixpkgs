{
  lib,
  stdenvNoCC,
  fetchDenoDeps,
  unzip,
  xxd,
  util-linux,
  glibc,
  stdenv,
  fetchurl,
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
      outputHash = denoDepsHash;
    }
  ),
  # Hash of the vendored dependencies. Leave empty if you dont know it yet
  denoDepsHash ? "",

  # Configuration for finding the main script and the config file 
  # The main script you would run with `deno run`
  script,
  # The deno.json config file. 
  # TODO: Add support for deno.jsonc and allow for projects without deno.json
  denoJson ? null,
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

  #   src,
  #   script,
  #   depsHash ? "",
  #   denoJson ? "deno.json",
  #   # Create a temporary directory, where deno can cache some things. Stops deno from whining about not being able to write to the deno directory.
  #   # Not used if compile is true.
  #   writableDenoDirectory ? true,
  #   # Just produce a single binary, instead of a whole directory.
  #   compile ? false,
  #   ...
  # }@args:

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
let
  # TODO: Add missing arguments
  deps = fetchDenoDeps (
    args
    // {
      src = src;
      script = script;
      outputHash = denoDepsHash;
    }
  );
  executableName = if args ? meta.mainProgram then args.meta.mainProgram else args.pname;
  denoRuntimeTable = {
    "1.44.4" = {
      x86_64-linux = {
        url = "https://dl.deno.land/release/v1.44.4/denort-x86_64-unknown-linux-gnu.zip";
        hash = "sha256-KdTDshZ5G2f07IaOerSpv6/rNhLTOejADgLW9LOXtYU=";
      };
      aarch64-linux = {
        url = "https://dl.deno.land/release/v1.44.4/denort-aarch64-unknown-linux-gnu.zip";
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };
    };
  };
  architectureToDenoRuntimeZip = {
    x86_64-linux = "denort-x86_64-unknown-linux-gnu.zip";
    aarch64-linux = "denort-aarch64-unknown-linux-gnu.zip";
  };
  denoRuntimeUrl =
    if denoRuntimeTable ? ${deno.version}.${stdenvNoCC.targetPlatform.system} then
      denoRuntimeTable.${deno.version}.${stdenvNoCC.targetPlatform.system}
    else
      {
        url = "https://dl.deno.land/release/v${deno.version}/${
          architectureToDenoRuntimeZip.${stdenvNoCC.targetPlatform.system}
        }";
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };
  denoRuntime = fetchurl denoRuntimeUrl;
in
# deps;
stdenvNoCC.mkDerivation (
  args
  // {
    nativeBuildInputs =
      [ deno ]
      ++ (
        if compile then
          [
            unzip
            xxd
            util-linux
            glibc
          ]
        else
          [ ]
      )
      ++ (if args ? nativeBuildInputs then args.nativeBuildInputs else [ ]);

    buildPhase = ''
      if test -z '${script}' ; then
        echo "error: You need to specify a script. It is probably something like 'main.ts'"
        echo "fix: Adjust you nix code to pass a main file."
        exit 1
      fi

      if ! test -f '${script}' ; then
        echo "error: The script '${script}' for your application does not exist."
        echo "fix: Run 'echo \"console.log(\\\"Hello world!\\\")\" > ${script}' to create it."
        exit 1
      fi

      if ! test -f "${denoJson}" ; then
        if test "${denoJson}" = "deno.json" ; then
          echo "error: There is no deno config file in your project. For now we need every project to have a config file."
          echo "fix: Run 'deno init' to create it."
        else
          echo "error: The deno config file at '${denoJson}' you specified does not exist."
          echo "fix: Create '${denoJson}'."
        fi
        exit 1
      fi

      if test -e "./vendor" || test -e "./node_modules" ; then
        ls -a
        echo "error: It looks like your project already contains some vendored dependencies. Good job, nice reproducibility. However buildDenoApplication doesnt support it for now." >&2
        echo "fix: Add support for vendored dependencies to buildDenoApplication and submit a patch" >&2
        echo "fix: Or just remove ./vendor and ./node_modules" >&2
        exit 1
      fi

      BUILD_DIR=$(mktemp -d)
      ln -s ${deps}/node_modules $BUILD_DIR/node_modules
      ln -s ${deps}/vendor $BUILD_DIR/vendor
      for file in $(find $src -maxdepth 1 -mindepth 1 -printf "%P\n") ; do
        ln -s $src/$file $BUILD_DIR/$file
      done
    '';

    installPhase =
      if compile then
        ''
          cd $BUILD_DIR
          export DENO_DIR="$(mktemp -d)"
          ln -s ${deps}/deno/npm "$DENO_DIR"
          mkdir -p $DENO_DIR/dl/release/v${deno.version}
          ln -s ${denoRuntime} $DENO_DIR/dl/release/v${deno.version}/denort-x86_64-unknown-linux-gnu.zip

          export DENO_NO_UPDATE_CHECK=true
          export DENO_NO_PACKAGE_JSON=true
          export DENO_JOBS=1
          deno compile --cached-only --vendor=true --node-modules-dir=true -c ${denoJson} -o $out/bin/${executableName} -A ${script}
        ''
      else
        ''
          mkdir -p $out
          mv $BUILD_DIR $out/module

          mkdir -p $out/bin
          cat << EOF > $out/bin/${executableName}
          #!/usr/bin/env bash
          ${
            if writableDenoDirectory then
              ''
                export DENO_DIR="\$(mktemp -td ${executableName}-XXXXXX)"
                ln -s ${deps}/deno/npm "\$DENO_DIR"
              ''
            else
              ''
                export DENO_DIR="${deps}/deno"
              ''
          }
          export DENO_NO_UPDATE_CHECK=true
          export DENO_NO_PACKAGE_JSON=true
          export DENO_JOBS=1
          exec ${lib.getExe deno} run --cached-only --vendor=true --node-modules-dir=true -c $out/module/${denoJson} -A $out/module/${script} "\$@"
          EOF
          chmod a+x $out/bin/${executableName}
        '';

    fixupPhase =
      if compile then
        ''
          # The last 40 bytes of the file have to be the d3n0l4nd trailer
          TRAILER=$(tail -c 40 $out/bin/${executableName} | hexdump -v -e '1/1 "%02x "')
          patchelf --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" $out/bin/${executableName}
          echo "$TRAILER" | xxd -r -p >>"$out/bin/${executableName}"
        ''
      else
        null;
  }
)
