{ lib
, stdenv
, which
, coreutils
, zlib
, openssl
, makeSetupHook
, dotnetCorePackages
  # Passed from ../default.nix
, dotnet-sdk
, dotnet-runtime
}:
let
  runtimeId = dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system;
in
{
  dotnetConfigureHook = makeSetupHook
    {
      name = "dotnet-configure-hook";
      substitutions = {
        runtimeId = lib.escapeShellArg runtimeId;
        dynamicLinker = "${stdenv.cc}/nix-support/dynamic-linker";
        libPath = lib.makeLibraryPath [
          stdenv.cc.cc.lib
          stdenv.cc.libc
          dotnet-sdk.passthru.icu
          zlib
          openssl
        ];
      };
    }
    ./dotnet-configure-hook.sh;

  dotnetBuildHook = makeSetupHook
    {
      name = "dotnet-build-hook";
      substitutions = {
        runtimeId = lib.escapeShellArg runtimeId;
      };
    }
    ./dotnet-build-hook.sh;

  dotnetCheckHook = makeSetupHook
    {
      name = "dotnet-check-hook";
      substitutions = {
        runtimeId = lib.escapeShellArg runtimeId;
      };
    }
    ./dotnet-check-hook.sh;

  dotnetInstallHook = makeSetupHook
    {
      name = "dotnet-install-hook";
      substitutions = {
        runtimeId = lib.escapeShellArg runtimeId;
      };
    }
    ./dotnet-install-hook.sh;

  dotnetFixupHook = makeSetupHook
    {
      name = "dotnet-fixup-hook";
      substitutions = {
        dotnetRuntime = dotnet-runtime;
        wrapperPath = lib.makeBinPath [ which coreutils ];
      };
    }
    ./dotnet-fixup-hook.sh;
}
