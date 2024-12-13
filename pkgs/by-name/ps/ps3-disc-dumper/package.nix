{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  zlib,
  openssl,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "ps3-disc-dumper";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "13xforever";
    repo = "ps3-disc-dumper";
    rev = "refs/tags/v${version}";
    hash = "sha256-m3TS9H6cbEAHn6PvYQDMzdKdnOnDSM4lxCTdHBCXLV4=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.sdk_9_0;
  projectFile = "UI.Console/UI.Console.csproj";
  nugetDeps = ./deps.nix;

  postPatch = ''
    substituteInPlace UI.Console/UI.Console.csproj \
      --replace-fail 'net6.0' 'net9.0'
  '';

  preConfigureNuGet = ''
    # This should really be in the upstream nuget.config
    dotnet nuget add source https://api.nuget.org/v3/index.json \
      -n nuget.org --configfile nuget.config
  '';

  runtimeDeps = [
    zlib
    openssl
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Handy utility to make decrypted PS3 disc dumps";
    homepage = "https://github.com/13xforever/ps3-disc-dumper";
    license = lib.licenses.mit;
    mainProgram = "ps3-disc-dumper";
    maintainers = with lib.maintainers; [
      evanjs
      gepbird
    ];
    platforms = [ "x86_64-linux" ];
  };
}
