{
  stdenv,
  lndir,
  lib,
}:

args@{
  bazel,
  registry ? null,
  bazelRepoCache ? null,
  bazelVendorDeps ? null,
  startupArgs ? [ ],
  commandArgs ? [ ],
  bazelPreBuild ? "",
  bazelPostBuild ? "",
  serverJavabase ? null,
  targets,
  command,
  ...
}:

stdenv.mkDerivation (
  {
    preBuildPhases = [ "preBuildPhase" ];
    preBuildPhase =
      (lib.optionalString (bazelRepoCache != null) ''
        # repo_cache needs to be writeable even in air-gapped builds
        mkdir repo_cache
        ${lndir}/bin/lndir -silent ${bazelRepoCache}/repo_cache repo_cache
      '')

      + (lib.optionalString (bazelVendorDeps != null) ''
        mkdir vendor_dir
        ${lndir}/bin/lndir -silent ${bazelVendorDeps}/vendor_dir vendor_dir

        # pin all deps to avoid re-fetch attempts by Bazel
        rm vendor_dir/VENDOR.bazel
        find vendor_dir -mindepth 1 -maxdepth 1 -type d -printf "pin(\"@@%P\")\n" > vendor_dir/VENDOR.bazel
      '')
      # keep preBuildPhase always defined as it is listed in preBuildPhases
      + ''
        true
      '';
    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)

      ${bazelPreBuild}

      ${bazel}/bin/bazel ${
        lib.escapeShellArgs (
          lib.optional (serverJavabase != null) "--server_javabase=${serverJavabase}"
          ++ [ "--batch" ]
          ++ startupArgs
        )
      } ${command} ${
        lib.escapeShellArgs (
          lib.optional (registry != null) "--registry=file://${registry}"
          ++ lib.optional (bazelRepoCache != null) "--repository_cache=repo_cache"
          ++ lib.optional (bazelVendorDeps != null) "--vendor_dir=vendor_dir"
          ++ commandArgs
          ++ targets
        )
      }

      ${bazelPostBuild}

      runHook postBuild
    '';

  }
  // args
)
