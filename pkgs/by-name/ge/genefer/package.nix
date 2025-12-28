{
  fetchFromGitHub,
  gmp,
  lib,
  ocl-icd,
  opencl-headers,
  stdenv,
  fetchurl,
  unzip,
  gnum4,
  pkg-config,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "genefer";
  version = "25.05.1";

  src = fetchFromGitHub {
    owner = "galloty";
    repo = "genefer22";
    rev = "87c9765f2ed3bc0803e832bfbad9e5660d12dc7a";
    hash = "sha256-eNb2e34EuKavtTkbsXgZb4MlwTkuImgR1uobRFT4qYk=";
  };

  nativeBuildInputs = [
    unzip
    autoconf
    automake
    libtool
    gnum4
    pkg-config
  ];

  enableParallelBuilding = true;
  buildInputs = [
    gmp
    ocl-icd
    opencl-headers
  ];

  # BOINC source fetch
  boincSrc = fetchurl {
    url = "https://github.com/BOINC/boinc/archive/refs/tags/client_release/8.2/8.2.0.zip";
    sha256 = "sha256-U+QCXkQMSYgtvTeecwQPTNZJYg52t8vL21Y3mZyhQsA=";
  };

  postPatch = ''

    # remove the static flags

    sed -i 's/-static-libgcc//g' genefer/Makefile_linux64
    sed -i 's/-static-libstdc++//g' genefer/Makefile_linux64
    sed -i 's/-static//g' genefer/Makefile_linux64

  '';

  buildPhase = ''
    runHook preBuild

    # build BOINC
    mkdir -p boinc_build
    unzip ${finalAttrs.boincSrc} -d boinc_build
    BOINC_ROOT_DIR=$(realpath boinc_build/boinc-client_release-*)

    pushd $BOINC_ROOT_DIR
    ./_autosetup
    ./configure --disable-server --disable-client --disable-manager
    make -C lib -j$NIX_BUILD_CORES
    make -C api -j$NIX_BUILD_CORES
    popd

    # create version.h
    cd src
    cat > version.h <<EOF
    #pragma once
    #define GENEFER_VERSION "${finalAttrs.version}"
    #define GENEFER_GIT_REV "nix"
    EOF

    # build genefer
    cd ../genefer

    make -f Makefile_linux64 \
    BOINC_DIR="$BOINC_ROOT_DIR" -j$NIX_BUILD_CORES

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ../bin/genefer $out/bin/genefer22
    install -Dm755 ../bin/geneferg $out/bin/genefer22-gpu

    mkdir -p $out/share/genefer22
    [ -d ../ocl ] && cp -r ../ocl $out/share/genefer22/

    runHook postInstall
  '';

  doInstallCheck = true;

  versionCheckProgram = "genefer22";
  versionCheckProgramArg = "-v";

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/genefer22 -v

    runHook postInstallCheck
  '';

  meta = {
    description = "Generalized Fermat Prime search program";
    longDescription = ''
      genefer is an OpenMP® application on CPU and an OpenCL™ application on GPU.
      It performs a fast probable primality test for numbers of the form b^2n + 1 with the Fermat test.
    '';
    homepage = "https://github.com/galloty/genefer22";
    maintainers = with lib.maintainers; [ dstremur ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "genefer22";
  };
})
