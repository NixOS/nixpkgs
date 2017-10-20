{ lib, stdenv, fetchgit, fetchFromGitHub, fetchpatch, cmake
, openblas, opencv3, libzip, boost, protobuf, openmpi
, onebitSGDSupport ? false
, cudaSupport ? false, cudatoolkit, nvidia_x11
, cudnnSupport ? false, cudnn
}:

assert cudnnSupport -> cudaSupport;

let
  # Old specific version required for CNTK.
  cub = fetchFromGitHub {
    owner = "NVlabs";
    repo = "cub";
    rev = "1.4.1";
    sha256 = "1lcdwblz03c0yq1lxndg566kg14b5qm14x5qixjbmz6wq85kgmqc";
  };

in stdenv.mkDerivation rec {
  name = "CNTK-${version}";
  version = "2.2";

  # Submodules
  src = fetchgit {
    url = "https://github.com/Microsoft/CNTK";
    rev = "v${version}";
    sha256 = "0q4knrwiyphb2fbqf9jzqvkz2jzj6jmbmang3lavdvsh7z0n8zz9";
  };

  patches = [
    # Fix "'exp' was not declared"
    (fetchpatch {
      url = "https://github.com/imriss/CNTK/commit/ef1cca6df95cc507deb8471df2c0dd8cbfeef23b.patch";
      sha256 = "0z7xyrxwric0c4h7rfs05f544mcq6d10wgs0vvfcyd2pcf410hy7";
    })
  ];

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
  ] ++ lib.optionals cudaSupport [
    "--cuda=yes"
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

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/Microsoft/CNTK";
    description = "An open source deep-learning toolkit";
    license = if onebitSGDSupport then licenses.unfreeRedistributable else licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
