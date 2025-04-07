{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  zlib,
  openssl,
  dotnetCorePackages,
  nix-update-script,
}:

buildDotnetModule rec {
  pname = "ps3-disc-dumper";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "13xforever";
    repo = "ps3-disc-dumper";
    tag = "v${version}";
    hash = "sha256-FtKFX7w60lAt7aMg/KNumFGESluYZf1/vzjdkLctkqs=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.sdk_9_0;
  dotnetFlags = [ "-p:TargetFramework=net9.0" ];
  dotnetRestoreFlags = [ "-p:Configuration=${buildType}" ];
  buildType = "Linux";
  projectFile = "UI.Avalonia/UI.Avalonia.csproj";
  nugetDeps = ./deps.json;

  preConfigureNuGet = ''
    # This should really be in the upstream nuget.config
    dotnet nuget add source https://api.nuget.org/v3/index.json \
      -n nuget.org --configfile nuget.config
  '';

  runtimeDeps = [
    zlib
    openssl
  ];

  passthru.updateScript = nix-update-script { };

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
