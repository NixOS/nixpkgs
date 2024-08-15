{ stdenv
, lib
, fetchFromGitHub
, buildDotnetModule
, dotnetCorePackages
, openssl
, zlib
, hostPlatform
, nix-update-script
}:

buildDotnetModule rec {
  pname = "pupdate";
  version = "3.11.1";

  src = fetchFromGitHub {
    owner = "mattpannella";
    repo = "${pname}";
    rev = "${version}";
    hash = "sha256-odlKNp6kjOAYeRIHnLniqkCXTi1UXF3szn8tJtrxzQU=";
  };

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    openssl
  ];

  # See https://github.com/NixOS/nixpkgs/pull/196648/commits/0fb17c04fe34ac45247d35a1e4e0521652d9c494
  patches = [ ./add-runtime-identifier.patch ];
  postPatch = ''
    substituteInPlace pupdate.csproj \
      --replace @RuntimeIdentifier@ "${dotnetCorePackages.systemToDotnetRid hostPlatform.system}"
  '';

  projectFile = "pupdate.csproj";

  nugetDeps = ./deps.nix;

  selfContainedBuild = true;

  executables = [ "pupdate" ];

  dotnetFlags = [
    "-p:PackageRuntime=${dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system} -p:TrimMode=partial"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

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
