{
  buildDotnetModule,
  dotnet-runtime,
  dotnet-sdk,
  fetchFromGitHub,
  gcc,
  git,
  glibcLocales,
  gtk3,
  hash,
  lib,
  mono,
  nugetDeps,
  projectFile,
  rev,
  version,
}:

let
  resources = fetchFromGitHub {
    owner = "renode";
    repo = "renode-resources";
    rev = "d3d69f8f17ed164ee23e46f0c06844a69bf4c004";
    hash = "sha256-wR3heL58NOQLENwCzL4lPM4KuvT/ON7dlc/KUqrlRjg=";
  };
  assemblyVersion =
    s:
    let
      part = lib.strings.splitString "-" s;
      result = builtins.head part;
    in
    result;

  informationalVersion = rev: builtins.substring 0 8 rev;
in
buildDotnetModule rec {
  inherit
    dotnet-runtime
    dotnet-sdk
    nugetDeps
    projectFile
    version
    ;

  pname = "renode";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    rev = rev;
    hash = hash;
    fetchSubmodules = true;
  };

  postPatch = ''
    # https://github.com/dotnet/roslyn/issues/37379#issuecomment-513371985
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
      CURRENT_INFORMATIONAL_VERSION="${informationalVersion src.rev}"
  '';

  # https://github.com/NixOS/nixpkgs/issues/38991
  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  env.LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";

  nativeBuildInputs = [ git ];

  runtimeDeps = [
    gtk3
    mono
  ];

  enableParallelBuilding = false;

  preBuild = ''
    mkdir -p lib/resources/
    ln -s ${resources}/* lib/resources/

    mkdir output
    mv src/Infrastructure/src/Emulator/Cores/linux-properties.csproj output/properties.csproj
    sed -i "s#/usr/bin/gcc#${gcc}/bin/gcc#g" output/properties.csproj
    sed -i "s#/usr/bin/ar#${gcc}/bin/ar#g" output/properties.csproj
  '';

  dotnetInstallFlags = [ "-p:TargetFramework=net6.0" ];

  preInstall = ''
    dotnetProjectFiles=(Renode_NET.sln)
  '';

  postInstall = "mv .renode-root $out/lib/renode";

  executables = [ "Renode" ];

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
