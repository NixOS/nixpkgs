{
  buildDotnetModule,
  cmake,
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

  nativeBuildInputs = [
    git
    cmake
    gcc
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

    # Build tlib
    CORES_PATH=$PWD/src/Infrastructure/src/Emulator/Cores
    CORES_BUILD_PATH="$CORES_PATH/obj/Release"
    CORES_BIN_PATH="$CORES_PATH/bin/Release"
    CORES=(arm.le arm.be arm64.le arm-m.le arm-m.be ppc.le ppc.be ppc64.le ppc64.be i386.le x86_64.le riscv.le riscv64.le sparc.le sparc.be xtensa.le)

    for core_config in ''${CORES[@]}
    do
      CORE="$(echo $core_config | cut -d '.' -f 1)"
      ENDIAN="$(echo $core_config | cut -d '.' -f 2)"
      BITS=32

      if [[ $CORE =~ "64" ]]; then
        BITS=64
      fi

      CMAKE_CONF_FLAGS="-DTARGET_ARCH=$CORE -DTARGET_WORD_SIZE=$BITS -DCMAKE_BUILD_TYPE=Release"
      CORE_DIR=$CORES_BUILD_PATH/$CORE/$ENDIAN
      mkdir -p $CORE_DIR
      pushd $CORE_DIR
      if [[ $ENDIAN == "be" ]]; then
          CMAKE_CONF_FLAGS+=" -DTARGET_WORDS_BIGENDIAN=1"
      fi
      cmake $CMAKE_CONF_FLAGS -DHOST_ARCH=i386 $CORES_PATH
      cmake --build . -j$NIX_BUILD_CORES
      CORE_BIN_DIR=$CORES_BIN_PATH/lib
      mkdir -p $CORE_BIN_DIR
      mv tlib/*.so $CORE_BIN_DIR/
      echo $CORE_BIN_DIR
      popd
    done
  '';

  dotnetInstallFlags = [ "-p:TargetFramework=net8.0" ];

  executables = [ "Renode" ];

  postFixup = ''
    mv .renode-root $out/lib/renode
  '';

  passthru.updateScript = unstableGitUpdater {
    url = meta.downloadPage;
    branch = "master";
    tagPrefix = "v";
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
