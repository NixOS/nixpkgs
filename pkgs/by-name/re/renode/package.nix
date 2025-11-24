{
  buildDotnetModule,
  cmake,
  dconf,
  dotnet-runtime_8,
  dotnet-sdk_6,
  fetchFromGitHub,
  fetchpatch,
  gcc,
  glibcLocales,
  gtk3-x11,
  gtk3,
  lib,
  mono,
  nix-update-script,
  python3Packages,
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

  pythonLibs =
    with python3Packages;
    makePythonPath [
      construct
      psutil
      pyyaml
      requests
      tkinter

      # from tools/csv2resd/requirements.txt
      construct

      # from tools/execution_tracer/requirements.txt
      pyelftools

      (robotframework.overrideDerivation (oldAttrs: {
        src = fetchFromGitHub {
          owner = "robotframework";
          repo = "robotframework";
          rev = "v6.1";
          hash = "sha256-l1VupBKi52UWqJMisT2CVnXph3fGxB63mBVvYdM1NWE=";
        };
        patches = (oldAttrs.patches or [ ]) ++ [
          (fetchpatch {
            # utest: Improve filtering of output sugar for Python 3.13+
            name = "python3.13-support.patch";
            url = "https://github.com/robotframework/robotframework/commit/921e352556dc8538b72de1e693e2a244d420a26d.patch";
            hash = "sha256-aSaror26x4kVkLVetPEbrJG4H1zstHsNWqmwqOys3zo=";
          })
        ];
      }))
    ];

in
buildDotnetModule rec {
  pname = "renode";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    rev = "20ad06d9379997829df309c5724be94ba4effedd";
    hash = "sha256-I/W3OAzHCN8rEIlDyBwI1ZDvKfHYYBDiqE9XkWHxo7o=";
    fetchSubmodules = true;
  };

  projectFile = "Renode_NET.sln";

  dotnet-runtime = dotnet-runtime_8;
  dotnet-sdk = dotnet-sdk_6;

  nugetDeps = ./deps.json;

  patches = [ ./renode-test.patch ];

  prePatch = ''
    substituteInPlace tools/building/createAssemblyInfo.sh \
      --replace CURRENT_INFORMATIONAL_VERSION="`git rev-parse --short=8 HEAD`" \
      CURRENT_INFORMATIONAL_VERSION="${builtins.substring 0 8 src.rev}"
  '';

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
  '';

  # https://github.com/NixOS/nixpkgs/issues/38991
  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  env.LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";

  nativeBuildInputs = [
    cmake
    gcc
  ];

  runtimeDeps = [
    gtk3
    mono
  ];

  dontUseCmakeConfigure = true;

  enableParallelBuilding = false;

  preBuild = ''
    mkdir -p lib/resources
    ln -s ${resources}/* lib/resources/

    mkdir output
    mv src/Infrastructure/src/Emulator/Cores/linux-properties.csproj output/properties.csproj
    sed -i "s#/usr/bin/gcc#${gcc}/bin/gcc#g" output/properties.csproj
    sed -i "s#/usr/bin/ar#${gcc}/bin/ar#g" output/properties.csproj

    # To fix value "" error in element <Import>
    rm -rf src/Directory.Build.targets

    CORES=(arm.le arm.be arm64.le arm-m.le arm-m.be ppc.le ppc.be ppc64.le ppc64.be i386.le x86_64.le riscv.le riscv64.le sparc.le sparc.be xtensa.le)
    for core_config in ''${CORES[@]}
    do
      CORE="$(echo $core_config | cut -d '.' -f 1)"
      ENDIAN="$(echo $core_config | cut -d '.' -f 2)"
      BITS=32

      if [[ $CORE =~ "64" ]]; then
        BITS=64
      fi

      SOURCE="${src}/src/Infrastructure/src/Emulator/Cores"
      CMAKE_CONF_FLAGS="-DTARGET_ARCH=$CORE -DTARGET_WORD_SIZE=$BITS -DCMAKE_BUILD_TYPE=Release -DCMAKE_LIBRARY_OUTPUT_DIRECTORY=$out/lib"
      CORE_DIR=build/$CORE/$ENDIAN
      mkdir -p $CORE_DIR
      pushd $CORE_DIR

      if [[ $ENDIAN == "be" ]]; then
          CMAKE_CONF_FLAGS+=" -DTARGET_WORDS_BIGENDIAN=1"
      fi

      cmake $CMAKE_CONF_FLAGS -DHOST_ARCH=i386 $SOURCE
      cmake --build . -j$NIX_BUILD_CORES
      popd
    done

    mkdir -p src/Infrastructure/src/Emulator/Cores/bin/Release/lib
    ln -s $out/lib/*.so src/Infrastructure/src/Emulator/Cores/bin/Release/lib
  '';

  dotnetInstallFlags = [ "-p:TargetFramework=net6.0" ];

  postInstall = ''
    mkdir -p $out/lib/renode
    mv * .renode-root $out/lib/renode

    makeWrapper "$out/lib/renode/renode-test" "$out/bin/renode-test" \
      --prefix PATH : "$out/lib/renode:${lib.makeBinPath [ dotnet-sdk ]}" \
      --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules" \
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gtk3-x11 ]}" \
      --prefix PYTHONPATH : "${pythonLibs}" \
      --set LOCALE_ARCHIVE "${glibcLocales}/lib/locale/locale-archive" \
  '';

  executables = [ "Renode" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/renode/renode/blob/${version}/CHANGELOG.rst";
    description = "Virtual development framework for complex embedded systems";
    downloadPage = "https://github.com/renode/renode";
    homepage = "https://renode.io";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      otavio
      znaniye
    ];
    platforms = [ "x86_64-linux" ];
  };
}
