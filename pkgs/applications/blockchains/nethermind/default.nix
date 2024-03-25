{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, snappy
, rocksdb
}:

let
  hash = "gr95y0LcjCC2S8ZYyKU7HD4cE2lrtktsjJK7Z24oj3w=";
  projectPath = "src/Nethermind/Nethermind.Runner";
in
buildDotnetModule rec {
  pname = "nethermind";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "NethermindEth";
    repo = pname;
    rev = "${version}";
    sha256 = "${hash}";
    fetchSubmodules = true;
  };

  projectFile = "${projectPath}/Nethermind.Runner.csproj";
  nugetDeps = ./deps.nix;

  patches = [
    # Skip trying to get the git hash during build, we write our own hash instead
    ./remove-git-hash.patch
  ];

  postPatch = ''
    echo "${hash}" > ${projectPath}/git-hash
  '';

  runtimeDeps = [
    rocksdb
    snappy
  ];

  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;

  buildType = "Release";

  meta = with lib; {
    description = ".NET Core Ethereum client";
    homepage = "https://nethermind.io/";
    maintainers = with maintainers; [ shazow ];
    license = licenses.lgpl3;
    platforms = dotnet-runtime.meta.platforms;
  };
}
