{ lib
, callPackage
, makeSetupHook
, makeWrapper
, dotnet-sdk
, dotnet-test-sdk
, disabledTests
, nuget-source
, dotnet-runtime
, runtimeDeps
, buildType
, runtimeId
}:
assert (builtins.isString runtimeId);

let
  libraryPath = lib.makeLibraryPath runtimeDeps;
in
{
  dotnetConfigureHook = callPackage ({ }:
    makeSetupHook {
      name = "dotnet-configure-hook";
      propagatedBuildInputs = [ dotnet-sdk nuget-source ];
      substitutions = {
        nugetSource = nuget-source;
        inherit runtimeId;
      };
    } ./dotnet-configure-hook.sh) { };

  dotnetBuildHook = callPackage ({ }:
    makeSetupHook {
      name = "dotnet-build-hook";
      propagatedBuildInputs = [ dotnet-sdk ];
      substitutions = {
        inherit buildType runtimeId;
      };
    } ./dotnet-build-hook.sh) { };

  dotnetCheckHook = callPackage ({ }:
    makeSetupHook {
      name = "dotnet-check-hook";
      propagatedBuildInputs = [ dotnet-test-sdk ];
      substitutions = {
        inherit buildType libraryPath;
        disabledTests = lib.optionalString (disabledTests != [])
          (let
            escapedNames = lib.lists.map (n: lib.replaceStrings [","] ["%2C"] n) disabledTests;
            filters = lib.lists.map (n: "FullyQualifiedName!=${n}") escapedNames;
          in
          "${lib.concatStringsSep "&" filters}");
      };
    } ./dotnet-check-hook.sh) { };

  dotnetInstallHook = callPackage ({ }:
    makeSetupHook {
      name = "dotnet-install-hook";
      propagatedBuildInputs = [ dotnet-sdk ];
      substitutions = {
        inherit buildType runtimeId;
      };
    } ./dotnet-install-hook.sh) { };

  dotnetFixupHook = callPackage ({ }:
    makeSetupHook {
      name = "dotnet-fixup-hook";
      propagatedBuildInputs = [ dotnet-runtime ];
      substitutions = {
        dotnetRuntime = dotnet-runtime;
        runtimeDeps = libraryPath;
      };
    } ./dotnet-fixup-hook.sh) { };
}
