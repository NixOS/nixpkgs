{
  buildDotnetModule,
  dotnet-runtime_6,
  dotnet-sdk_6,
  fetchFromGitHub,
  gcc,
  git,
  gtk3,
  lib,
  mono,
}:

let
  resources = fetchFromGitHub {
    owner = "renode";
    repo = "renode-resources";
    rev = "d3d69f8f17ed164ee23e46f0c06844a69bf4c004";
    hash = "sha256-wR3heL58NOQLENwCzL4lPM4KuvT/ON7dlc/KUqrlRjg=";
  };
in
buildDotnetModule rec {
  pname = "renode";
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    tag = "v${version}";
    hash = "sha256-sZhO332seVPuYhk6Cx5UEPyGWfN9TkuavvpVyLJU2Sw=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs build.sh tools/

    sed -i 's/AssemblyVersion("%VERSION%.*")/AssemblyVersion("1.5.3.0")/g' src/Renode/Properties/AssemblyInfo.template
    sed -i 's/AssemblyVersion("1.0.*")/AssemblyVersion("1.0.0.0")/g' lib/AntShell/AntShell/Properties/AssemblyInfo.cs lib/CxxDemangler/CxxDemangler/Properties/AssemblyInfo.cs #to fix determinism build error
  '';

  projectFile = "Renode_NET.sln";

  nugetDeps = ./deps.json;

  dotnet-runtime = dotnet-runtime_6;
  dotnet-sdk = dotnet-sdk_6;

  dotnetBuildFlags = [ "-p:DeterministicSourcePaths=false" ];

  buildInputs = [ git ]; # needed for createAsemblyInfo.cs right

  runtimeDeps = [
    gtk3
    mono
  ];

  preBuild = ''
    mkdir -p lib/resources/
    ln -s ${resources}/* lib/resources/

    mkdir output
    mv $PWD/src/Infrastructure/src/Emulator/Cores/linux-properties.csproj $PWD/output/properties.csproj
    sed -i "s#/usr/bin/gcc#${gcc}/bin/gcc#g" $PWD/output/properties.csproj
    sed -i "s#/usr/bin/ar#${gcc}/bin/ar#g" $PWD/output/properties.csproj

    dotnet build $PWD/lib/cctask/CCTask_NET.sln -p:Configuration=Release -p:Platform="Any CPU"
  '';

  dotnetInstallFlags = [ "-p:TargetFramework=net6.0" ];

  executables = [ "Renode" ];

  postFixup = ''
    mv .renode-root $out/lib/renode
  '';

  meta = {
    changelog = "https://github.com/renode/renode/blob/${version}/CHANGELOG.rst";
    description = "Virtual development framework for complex embedded systems";
    downloadPage = "https://github.com/renode/renode";
    homepage = "https://renode.io";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ otavio ];
    platforms = [ "x86_64-linux" ];
  };
}
