{
  stdenv,
  lib,
  which,
  coreutils,
  makeSetupHook,
  # Passed from ../default.nix
  dotnet-sdk,
  dotnet-runtime,
}:
{
  dotnetConfigureHook = makeSetupHook {
    name = "dotnet-configure-hook";
  } ./dotnet-configure-hook.sh;

  dotnetBuildHook = makeSetupHook {
    name = "dotnet-build-hook";
  } ./dotnet-build-hook.sh;

  dotnetCheckHook = makeSetupHook {
    name = "dotnet-check-hook";
  } ./dotnet-check-hook.sh;

  dotnetInstallHook = makeSetupHook {
    name = "dotnet-install-hook";
  } ./dotnet-install-hook.sh;

  dotnetFixupHook = makeSetupHook {
    name = "dotnet-fixup-hook";
    substitutions = {
      dotnetRuntime = if (dotnet-runtime != null) then dotnet-runtime else null;
      wrapperPath = lib.optionals (!stdenv.hostPlatform.isWindows) (
        lib.makeBinPath [
          which
          coreutils
        ]
      );
    };
  } ./dotnet-fixup-hook.sh;
}
