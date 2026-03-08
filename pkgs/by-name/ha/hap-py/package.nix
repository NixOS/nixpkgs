{
  autoconf,
  bcftools,
  boost,
  bzip2,
  cmake,
  curl,
  fetchFromGitHub,
  htslib,
  lib,
  libdeflate,
  makeWrapper,
  perl,
  python3,
  rtg-tools,
  samtools,
  stdenv,
  xz,
  zlib,
}:

let
  # Bcftools needs perl
  runtime = [
    bcftools
    htslib
    my-python
    perl
    samtools
  ];
  my-python-packages =
    p: with p; [
      bx-python
      pysam
      pandas
      psutil
      scipy
    ];
  my-python = python3.withPackages my-python-packages;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hap.py";
  version = "0.3.15";

  src = fetchFromGitHub {
    owner = "Illumina";
    repo = "hap.py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K8XXhioMGMHw56MKvp0Eo8S6R36JczBzGRaBz035zRQ=";
  };

  # CMake 4 dropped support of versions lower than 3.5,
  # versions lower than 3.10 are deprecated.
  # https://github.com/NixOS/nixpkgs/issues/445447
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        "cmake_minimum_required (VERSION 2.8)" \
        "cmake_minimum_required (VERSION 3.10)"


    # Boost 1.89 no longer provides a boost_system CMake component package,
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        "filesystem system program_options" \
        "filesystem program_options"

    # Insert missing include for uint64_t
    sed -i '/#include <vector>/a #include <cstdint>' src/c++/include/helpers/Roc.hh
  '';

  patches = [
    # Compatibility with nix for boost and library flags : zlib, bzip2, curl, crypto, lzma
    ./boost-library-flags.patch
    # Update to python3
    ./python3.patch
  ];

  env.NIX_LDFLAGS = toString [ "-ldeflate" ];

  nativeBuildInputs = [
    autoconf
    cmake
    makeWrapper
  ];
  buildInputs = [
    boost
    bzip2
    curl
    htslib
    libdeflate
    my-python
    rtg-tools
    xz
    zlib
  ];

  env = {
    # For illumina script
    BOOST_ROOT = "${boost.out}";
    ZLIBSTATIC = "${zlib.static}";

    # For cmake : boost lib and includedir are in different location
    BOOST_LIBRARYDIR = "${boost.out}/lib";
    BOOST_INCLUDEDIR = "${boost.dev}/include";
  };

  postFixup = ''
    wrapProgram $out/bin/hap.py \
       --set PATH ${lib.makeBinPath runtime} \
       --add-flags "--engine-vcfeval-path=${lib.getExe rtg-tools}"
  '';

  meta = {
    description = "Compare genetics variants against a gold dataset";
    homepage = "https://github.com/Illumina/hap.py";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ apraga ];
    mainProgram = "hap.py";
  };
})
