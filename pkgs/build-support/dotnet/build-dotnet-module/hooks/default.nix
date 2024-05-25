{ lib
, stdenv
, which
, coreutils
, zlib
, openssl
, callPackage
, makeSetupHook
, makeWrapper
, dotnet-sdk
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
  dotnetConfigureHook = makeSetupHook
    {
      name = "dotnet-configure-hook";
      substitutions = {
        nugetSource = nuget-source;
        dynamicLinker = "${stdenv.cc}/nix-support/dynamic-linker";
        libPath = lib.makeLibraryPath [
          stdenv.cc.cc.lib
          stdenv.cc.libc
          dotnet-sdk.passthru.icu
          zlib
          openssl
        ];
        inherit runtimeId;
      };
    }
    ./dotnet-configure-hook.sh;

  dotnetBuildHook = makeSetupHook
    {
      name = "dotnet-build-hook";
      substitutions = {
        inherit buildType runtimeId;
      };
    }
    ./dotnet-build-hook.sh;

  dotnetCheckHook = makeSetupHook
    {
      name = "dotnet-check-hook";
      substitutions = {
        inherit buildType runtimeId libraryPath;
        disabledTests = lib.optionalString (disabledTests != [ ])
          (
            let
              escapedNames = lib.lists.map (n: lib.replaceStrings [ "," ] [ "%2C" ] n) disabledTests;
              filters = lib.lists.map (n: "FullyQualifiedName!=${n}") escapedNames;
            in
            "${lib.concatStringsSep "&" filters}"
          );
      };
    }
    ./dotnet-check-hook.sh;

  dotnetInstallHook = makeSetupHook
    {
      name = "dotnet-install-hook";
      substitutions = {
        inherit buildType runtimeId;
      };
    }
    ./dotnet-install-hook.sh;

  dotnetFixupHook = makeSetupHook
    {
      name = "dotnet-fixup-hook";
      substitutions = {
        dotnetRuntime = dotnet-runtime;
        runtimeDeps = libraryPath;
        shell = stdenv.shell;
        which = "${which}/bin/which";
        dirname = "${coreutils}/bin/dirname";
        realpath = "${coreutils}/bin/realpath";
      };
    }
    ./dotnet-fixup-hook.sh;
}
