{ lib
, stdenv
, which
, coreutils
, zlib
, openssl
, makeSetupHook
, zip
  # Passed from ../default.nix
, dotnet-sdk
, dotnet-runtime
}:
{
  dotnetConfigureHook = makeSetupHook
    {
      name = "dotnet-configure-hook";
      substitutions = {
        dynamicLinker = "${stdenv.cc}/nix-support/dynamic-linker";
        libPath = lib.makeLibraryPath [
          stdenv.cc.cc
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
    }
    ./dotnet-build-hook.sh;

  dotnetCheckHook = makeSetupHook
    {
      name = "dotnet-check-hook";
    }
    ./dotnet-check-hook.sh;

  dotnetInstallHook = makeSetupHook
    {
      name = "dotnet-install-hook";
      substitutions = {
        inherit zip;
      };
    }
    ./dotnet-install-hook.sh;

  dotnetFixupHook = makeSetupHook
    {
      name = "dotnet-fixup-hook";
      substitutions = {
        # this is used for DOTNET_ROOT, so we need unwrapped
        dotnetRuntime = if (dotnet-runtime != null) then dotnet-runtime.unwrapped else null;
        wrapperPath = lib.makeBinPath [ which coreutils ];
      };
    }
    ./dotnet-fixup-hook.sh;
}
