{
  stdenv,
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  openssl,
  zlib,
  nix-update-script,
}:

buildDotnetModule rec {
  pname = "pupdate";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "mattpannella";
    repo = "pupdate";
    rev = "${version}";
    hash = "sha256-LyTa53jJegF1vBrCi5u/JEmNWPXNPCGfRmfxFYPtJ90=";
  };

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    zlib
    openssl
  ];

  # See https://github.com/NixOS/nixpkgs/pull/196648/commits/0fb17c04fe34ac45247d35a1e4e0521652d9c494
  patches = [ ./add-runtime-identifier.patch ];
  postPatch = ''
    substituteInPlace pupdate.csproj \
      --replace-fail @RuntimeIdentifier@ "${dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system}"
  '';

  projectFile = "pupdate.csproj";

  nugetDeps = ./deps.json;

  selfContainedBuild = true;

  executables = [ "pupdate" ];

  dotnetFlags = [
    "-p:PackageRuntime=${dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system} -p:TrimMode=partial"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/mattpannella/pupdate";
    description = "Update utility for the openFPGA cores, firmware, and other stuff on your Analogue Pocket";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ p-rintz ];
    mainProgram = "pupdate";
  };
}
