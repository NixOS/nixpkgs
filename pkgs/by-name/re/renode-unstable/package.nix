{
  buildDotnetModule,
  callPackage,
  dotnet-runtime_8,
  dotnet-sdk_6,
  fetchFromGitHub,
  gcc,
  glibcLocales,
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

  pname = "renode";
  version = "1.15.3-unstable-2025-07-04";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    rev = "a02ab2a10ea7793e6ae5422435e4cdcca2f2084d";
    hash = "sha256-pta0lYZ4+IDPnB4OttVQvclBCyyDfP8JUghMiC/BQME=";
    fetchSubmodules = true;
  };

  assemblyVersion =
    s:
    let
      part = lib.strings.splitString "-" s;
      result = builtins.head part;
    in
    result;

  informationalVersion = builtins.substring 0 8 src.rev;
in
buildDotnetModule rec {
  inherit pname version src;

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

    # Fixes determinism build error
    sed -i 's/AssemblyVersion("%VERSION%.*")/AssemblyVersion("${assemblyVersion version}")/g' src/Renode/Properties/AssemblyInfo.template
    sed -i 's/AssemblyVersion("1.0.*")/AssemblyVersion("1.0.0.0")/g' lib/AntShell/AntShell/Properties/AssemblyInfo.cs lib/CxxDemangler/CxxDemangler/Properties/AssemblyInfo.cs

    substituteInPlace tools/building/createAssemblyInfo.sh \
      --replace CURRENT_INFORMATIONAL_VERSION="`git rev-parse --short=8 HEAD`" \
      CURRENT_INFORMATIONAL_VERSION="${informationalVersion}"

    rm -rf src/Directory.Build.targets # To fix value "" error in element <Import>
  '';

  dontUseCmakeConfigure = true;

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnet-sdk_6;
  dotnet-runtime = dotnet-runtime_8;

  # https://github.com/NixOS/nixpkgs/issues/38991
  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  env.LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";

  dotnetFlags = [ "-p:TargetFrameworks=net6.0" ];

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

  dotnetInstallFlags = [ "-p:TargetFramework=net6.0" ];

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
