{
  lib,
  stdenv,
  which,
  coreutils,
  zlib,
  openssl,
  makeSetupHook,
  zip,
  # Passed from ../default.nix
  dotnet-sdk,
  dotnet-runtime,
}:
makeSetupHook {
  name = "dotnet-hook";
  substitutions = {
    dynamicLinker = "${stdenv.cc}/nix-support/dynamic-linker";
    libPath = lib.makeLibraryPath [
      stdenv.cc.cc
      stdenv.cc.libc
      dotnet-sdk.passthru.icu
      zlib
      openssl
    ];
    inherit zip;
    dotnetRuntime = if (dotnet-runtime != null) then dotnet-runtime else null;
    wrapperPath = lib.makeBinPath [
      which
      coreutils
    ];
  };
} ./dotnet-hook.sh
