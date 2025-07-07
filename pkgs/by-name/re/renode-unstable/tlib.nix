{
  cmake,
  renode-unstable,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  name = "tlib";
  version = renode-unstable.version;

  src = renode-unstable.src;

  nativeBuildInputs = [ cmake ];

  dontUseCmakeConfigure = true;

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/lib

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

    runHook postBuild
  '';
}
