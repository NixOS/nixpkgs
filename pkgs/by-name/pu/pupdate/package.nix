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
  version = "3.20.0";

  src = fetchFromGitHub {
    owner = "mattpannella";
    repo = "pupdate";
    rev = "${version}";
    hash = "sha256-kdxqG1Vw6jRT/YyRLi60APpayYyLG73KqAFga8N9G2A=";
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
      --replace @RuntimeIdentifier@ "${dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system}"
  '';

  projectFile = "pupdate.csproj";

  nugetDeps = ./deps.json;

  selfContainedBuild = true;

  executables = [ "pupdate" ];

  dotnetFlags = [
    "-p:PackageRuntime=${dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system} -p:TrimMode=partial"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/mattpannella/pupdate";
    description = "Pupdate - A thing for updating your Analogue Pocket";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ p-rintz ];
    mainProgram = "pupdate";
  };
}
