{
  buildDotnetModule,
  callPackage,
  fetchFromGitHub,
  gcc,
  git,
  gtk3,
  lib,
  mono,
  unstableGitUpdater,
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
  version = "1.15.3-unstable-2025-06-18";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    rev = "08e83a23c4e0976dde65c502d15c8c965105c943";
    hash = "sha256-l+TIpe2enxLXEZ1twAp2C0bX4dv3kr0/tMOZqyu4l9E=";
    fetchSubmodules = true;
  };

  projectFile = "Renode_NET.sln";

  postPatch = ''
    cat << EOF > Directory.Build.props
      <Project>
        <ItemGroup>
          <SourceRoot Include="$(MSBuildThisFileDirectory)/"/>
        </ItemGroup>
      </Project>
    EOF

    patchShebangs build.sh tools/

    sed -i 's/AssemblyVersion("%VERSION%.*")/AssemblyVersion("1.0.0.0")/g' src/Renode/Properties/AssemblyInfo.template
    sed -i 's/AssemblyVersion("1.0.*")/AssemblyVersion("1.0.0.0")/g' lib/AntShell/AntShell/Properties/AssemblyInfo.cs lib/CxxDemangler/CxxDemangler/Properties/AssemblyInfo.cs #to fix determinism build error

    rm -rf src/Directory.Build.targets # To fix value "" error in element <Import>
  '';

  dontUseCmakeConfigure = true;

  nugetDeps = ./deps.json;

  dotnetFlags = [ "-p:TargetFrameworks=net8.0" ];

  enableParallelBuilding = false;

  nativeBuildInputs = [ git ];

  buildInputs = [
    passthru.deps.tlib
  ];

  runtimeDeps = [
    gtk3
    mono
  ];

  preBuild = ''
    mkdir -p lib/resources/
    ln -s ${resources}/* lib/resources/

    mkdir output
    mv src/Infrastructure/src/Emulator/Cores/linux-properties.csproj output/properties.csproj
    sed -i "s#/usr/bin/gcc#${gcc}/bin/gcc#g" output/properties.csproj
    sed -i "s#/usr/bin/ar#${gcc}/bin/ar#g" output/properties.csproj

    mkdir -p src/Infrastructure/src/Emulator/Cores/bin/Release/lib
    ln -s ${passthru.deps.tlib}/lib/*.so src/Infrastructure/src/Emulator/Cores/bin/Release/lib
  '';

  dotnetInstallFlags = [ "-p:TargetFramework=net8.0" ];

  postInstall = "mv .renode-root $out/lib/renode";

  executables = [ "Renode" ];

  passthru = {
    deps.tlib = callPackage ./tlib.nix { };

    updateScript = unstableGitUpdater {
      url = meta.downloadPage;
      branch = "master";
      tagPrefix = "v";
    };
  };

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
