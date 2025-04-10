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
    tag = "v${version}";
    hash = "sha256-m3TS9H6cbEAHn6PvYQDMzdKdnOnDSM4lxCTdHBCXLV4=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.sdk_9_0;
  projectFile = "UI.Console/UI.Console.csproj";
  nugetDeps = ./deps.json;

  postPatch = ''
    substituteInPlace UI.Console/UI.Console.csproj \
      --replace-fail 'net6.0' 'net9.0'
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
