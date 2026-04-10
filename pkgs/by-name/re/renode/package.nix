{
  buildDotnetModule,
  cmake,
  dconf,
  dotnetCorePackages,
  fetchFromGitHub,
  fetchpatch,
  gcc,
  glibcLocalesUtf8,
  gtk3-x11,
  gtk3,
  lib,
  python313Packages,
  stdenv,
}:

let
  hostArch =
    if stdenv.hostPlatform.isx86 then
      "i386"
    else if stdenv.hostPlatform.isAarch64 then
      "aarch64"
    else
      throw "renode: unsupported host architecture ${stdenv.hostPlatform.system}";
  rid = dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system;
  llvmDisasLib =
    if stdenv.hostPlatform.isAarch64 then "libllvm-disas-aarch64.so" else "libllvm-disas.so";

  targetFramework = "net10.0";
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  resources = fetchFromGitHub {
    owner = "renode";
    repo = "renode-resources";
    rev = "14b80cde0a136b684f316eb7f6a31aeaae0684bf";
    hash = "sha256-OdRNcvFnpAMGnxIYH9brmHKREVp3gICqGjM3sJC1SEI=";
  };

  pythonLibs =
    with python313Packages;
    makePythonPath [
      construct
      psutil
      pyyaml
      requests
      tkinter
      telnetlib3

      # from tools/csv2resd/requirements.txt
      construct

      # from tools/execution_tracer/requirements.txt
      pyelftools

      (robotframework.overridePythonAttrs (oldAttrs: {
        version = "6.1";
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
buildDotnetModule (finalAttrs: {
  pname = "renode";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    rev = "ab721d88e135a1bcb8ed2ecc5a38f51cbe61fdd2";
    hash = "sha256-vVd1ZTz5+iuKjZh7gxgVvX496+FrTxVSV+3neWUy9/Y=";
    fetchSubmodules = true;
  };

  disallowedReferences = [
    cmake
    gcc
    dotnet-sdk
  ];

  projectFile = "src/Renode/Renode.csproj";

  inherit dotnet-sdk dotnet-runtime;

  nugetDeps = ./deps.json;

  patches = [ ./renode-test.patch ];

  dotnetFlags = [
    "-p:Architecture=${hostArch}"
    "-p:Version=${lib.head (lib.splitString "-" finalAttrs.version)}"
    "-p:InformationalVersion=${finalAttrs.version}+git${finalAttrs.src.rev}"
  ];

  dotnetInstallFlags = [ "-p:TargetFramework=${targetFramework}" ];

  installPath = "${placeholder "out"}/lib/renode";

  postPatch = ''
    # https://github.com/dotnet/roslyn/issues/37379#issuecomment-513371985
    cat << 'EOF' > Directory.Build.props
    <Project>
      <ItemGroup>
        <SourceRoot Include="$(MSBuildThisFileDirectory)/"/>
      </ItemGroup>
    </Project>
    EOF

    cat << EOF > Directory.Build.targets
    <Project>
      <PropertyGroup>
        <TargetFrameworks>${targetFramework}</TargetFrameworks>
        <EnableWindowsTargeting>true</EnableWindowsTargeting>
      </PropertyGroup>
    </Project>
    EOF

    patchShebangs build.sh tools/
  '';

  nativeBuildInputs = [
    cmake
    gcc
  ];

  runtimeDeps = [
    gtk3
  ];

  dontUseCmakeConfigure = true;

  enableParallelBuilding = false;

  preBuild = ''
    mkdir -p lib/resources
    ln -s ${resources}/* lib/resources/

    pushd tools/building
    ./check_weak_implementations.sh
    popd

    CORES_PATH="$PWD/src/Infrastructure/src/Emulator/Cores"
    NATIVE_CORES_BUILD_PATH="$CORES_PATH/obj/Release/${rid}"
    NATIVE_CORES_BIN_PATH="$CORES_PATH/bin/Release/${rid}"
    mkdir -p "$NATIVE_CORES_BIN_PATH"

  ''
  + lib.optionalString (hostArch == "i386") ''
    mkdir -p "$NATIVE_CORES_BUILD_PATH/virt"
    pushd "$NATIVE_CORES_BUILD_PATH/virt"
    cmake -DCMAKE_BUILD_TYPE=Release "$CORES_PATH/virt"
    cmake --build . -j$NIX_BUILD_CORES
    cp -v *.so "$NATIVE_CORES_BIN_PATH/"
    popd

  ''
  + ''
    CORES=(arm.le arm.be arm64.le arm-m.le arm-m.be ppc.le ppc.be ppc64.le ppc64.be i386.le x86_64.le riscv.le riscv64.le sparc.le sparc.be xtensa.le arm-experimental.le)
    for core_config in "''${CORES[@]}"; do
      CORE="$(echo $core_config | cut -d '.' -f 1)"
      ENDIAN="$(echo $core_config | cut -d '.' -f 2)"
      BITS=32
      if [[ $CORE =~ "64" || $CORE =~ ^arm-experimental ]]; then
        BITS=64
      fi

      CMAKE_CONF_FLAGS="-DTARGET_ARCH=$CORE -DTARGET_WORD_SIZE=$BITS -DCMAKE_BUILD_TYPE=Release"
      if [[ $ENDIAN == "be" ]]; then
        CMAKE_CONF_FLAGS+=" -DTARGET_WORDS_BIGENDIAN=1"
      fi

      CORE_DIR="$NATIVE_CORES_BUILD_PATH/$CORE/$ENDIAN"
      mkdir -p "$CORE_DIR"
      pushd "$CORE_DIR"
      cmake $CMAKE_CONF_FLAGS -DHOST_ARCH=${hostArch} "$CORES_PATH"
      cmake --build . -j$NIX_BUILD_CORES
      cp -v tlib/*.so "$NATIVE_CORES_BIN_PATH/"
      popd
    done

    mkdir -p output/bin/Release/platform-lib
    cp -r "$CORES_PATH/bin/Release/." output/bin/Release/platform-lib
    cp lib/resources/llvm/${llvmDisasLib} output/bin/Release/platform-lib/${rid}/libllvm-disas.so

    unset version versionForDotnet
  '';

  postInstall = ''
    cp -r output/bin/Release/platform-lib $out/lib/renode/

    rm -rf output
    find . -type d \( -name bin -o -name obj \) -prune -exec rm -rf {} +
    mv * .renode-root $out/lib/renode

    makeWrapper "$out/lib/renode/renode-test" "$out/bin/renode-test" \
      --prefix PATH : "$out/lib/renode:${lib.makeBinPath [ dotnet-runtime ]}" \
      --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules" \
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gtk3-x11 ]}" \
      --prefix PYTHONPATH : "${pythonLibs}" \
      --set LOCALE_ARCHIVE "${glibcLocalesUtf8}/lib/locale/locale-archive"
  '';

  postFixup = ''
    mv $out/bin/Renode $out/bin/renode
  '';

  executables = [ "Renode" ];

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/renode/renode/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    description = "Virtual development framework for complex embedded systems";
    downloadPage = "https://github.com/renode/renode";
    homepage = "https://renode.io";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      otavio
      znaniye
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
