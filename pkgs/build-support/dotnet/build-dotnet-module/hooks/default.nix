{ lib
, callPackage
, makeSetupHook
, makeWrapper
, jq
, dotnet-sdk
, dotnet-test-sdk
, disabledTests
, nuget-source
, dotnet-runtime
, runtimeDeps
, buildType
, dontSetNugetSource
}:

let
  libraryPath = lib.makeLibraryPath runtimeDeps;
in
{
  dotnetConfigureHook = callPackage ({ }:
    makeSetupHook {
      name = "dotnet-configure-hook";
      deps = [ dotnet-sdk ];
      substitutions = {
        nugetSource = lib.optional (!dontSetNugetSource) nuget-source;
      };
    } ./dotnet-configure-hook.sh) { };

  dotnetValidateLockfileHook = callPackage ({ }:
    makeSetupHook {
      name = "dotnet-validate-lockfile-hook";
      deps = [ jq ];
    } ./dotnet-validate-lockfile.sh) { };

  dotnetBuildHook = callPackage ({ }:
    makeSetupHook {
      name = "dotnet-build-hook";
      deps = [ dotnet-sdk ];
      substitutions = {
        inherit buildType;
      };
    } ./dotnet-build-hook.sh) { };

  dotnetCheckHook = callPackage ({ }:
    makeSetupHook {
      name = "dotnet-check-hook";
      deps = [ dotnet-test-sdk ];
      substitutions = {
        inherit buildType libraryPath;
        disabledTests = lib.optionalString (disabledTests != [])
          (lib.concatStringsSep "&FullyQualifiedName!=" disabledTests);
      };
    } ./dotnet-check-hook.sh) { };

  dotnetInstallHook = callPackage ({ }:
    makeSetupHook {
      name = "dotnet-install-hook";
      deps = [ dotnet-sdk ];
      substitutions = {
        inherit buildType;
      };
    } ./dotnet-install-hook.sh) { };

  dotnetFixupHook = callPackage ({ }:
    makeSetupHook {
      name = "dotnet-fixup-hook";
      deps = [ dotnet-runtime ];
      substitutions = {
        dotnetRuntime = dotnet-runtime;
        runtimeDeps = libraryPath;
      };
    } ./dotnet-fixup-hook.sh) { };
}
