{ config, lib, stdenv, fetchgit, fetchFromGitHub, cmake
, openblas, opencv3, libzip, boost, protobuf, openmpi
, onebitSGDSupport ? false
, cudaSupport ? config.cudaSupport or false, cudatoolkit, nvidia_x11
, cudnnSupport ? cudaSupport, cudnn
}:

assert cudnnSupport -> cudaSupport;

let
  # Old specific version required for CNTK.
  cub = fetchFromGitHub {
    owner = "NVlabs";
    repo = "cub";
    rev = "1.7.4";
    sha256 = "0ksd5n1lxqhm5l5cd2lps4cszhjkf6gmzahaycs7nxb06qci8c66";
  };

in stdenv.mkDerivation rec {
  name = "CNTK-${version}";
  version = "2.4";

  # Submodules
  src = fetchgit {
    url = "https://github.com/Microsoft/CNTK";
    rev = "v${version}";
    sha256 = "0m28wb0ljixcpi14g3gcfiraimh487yxqhd9yrglgyvjb69x597y";
  };

  patches = [ ./fix_std_bind.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openblas opencv3 libzip boost protobuf openmpi ]
             ++ lib.optional cudaSupport cudatoolkit
             ++ lib.optional cudnnSupport cudnn;

  configureFlags = [
    "--with-opencv=${opencv3}"
    "--with-libzip=${libzip.dev}"
    "--with-openblas=${openblas}"
    "--with-boost=${boost.dev}"
    "--with-protobuf=${protobuf}"
    "--with-mpi=${openmpi}"
    "--cuda=${if cudaSupport then "yes" else "no"}"
    # FIXME
    "--asgd=no"
  ] ++ lib.optionals cudaSupport [
    "--with-cuda=${cudatoolkit}"
    "--with-gdk-include=${cudatoolkit}/include"
    "--with-gdk-nvml-lib=${nvidia_x11}/lib"
    "--with-cub=${cub}"
  ] ++ lib.optional onebitSGDSupport "--1bitsgd=yes";

  configurePhase = ''
    sed -i \
      -e 's,^GIT_STATUS=.*,GIT_STATUS=,' \
      -e 's,^GIT_COMMIT=.*,GIT_COMMIT=v${version},' \
      -e 's,^GIT_BRANCH=.*,GIT_BRANCH=v${version},' \
      -e 's,^BUILDER=.*,BUILDER=nixbld,' \
      -e 's,^BUILDMACHINE=.*,BUILDMACHINE=machine,' \
      -e 's,^BUILDPATH=.*,BUILDPATH=/homeless-shelter,' \
      -e '/git does not exist/d' \
      Tools/generate_build_info

    patchShebangs .
    mkdir build
    cd build
    ${lib.optionalString cudnnSupport ''
      mkdir cuda
      ln -s ${cudnn}/include cuda
      export configureFlags="$configureFlags --with-cudnn=$PWD"
    ''}
    ../configure $configureFlags
  '';

  installPhase = ''
    mkdir -p $out/bin
    # Moving to make patchelf remove references later.
    mv lib $out
    cp bin/cntk $out/bin
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = https://github.com/Microsoft/CNTK;
    description = "An open source deep-learning toolkit";
    license = if onebitSGDSupport then licenses.unfreeRedistributable else licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
