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
stdenv.mkDerivation rec {
  pname = "hap.py";
  version = "0.3.15";

  src = fetchFromGitHub {
    owner = "Illumina";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-K8XXhioMGMHw56MKvp0Eo8S6R36JczBzGRaBz035zRQ=";
  };
  # For illumina script
  BOOST_ROOT = "${boost.out}";
  ZLIBSTATIC = "${zlib.static}";
  # For cmake : boost lib and includedir are in differernt location
  BOOST_LIBRARYDIR = "${boost.out}/lib";
  BOOST_INCLUDEDIR = "${boost.dev}/include";

  patches = [
    # Compatibility with nix for boost and library flags : zlib, bzip2, curl, crypto, lzma
    ./boost-library-flags.patch
    # Update to python3
    ./python3.patch
  ];
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
    my-python
    rtg-tools
    xz
    zlib
  ];

  postFixup = ''
    wrapProgram $out/bin/hap.py \
       --set PATH ${lib.makeBinPath runtime} \
       --add-flags "--engine-vcfeval-path=${rtg-tools}/bin/rtg"
  '';

  meta = with lib; {
    description = "Compare genetics variants against a gold dataset";
    homepage = "https://github.com/Illumina/hap.py";
    license = licenses.bsd2;
    maintainers = with maintainers; [ apraga ];
    mainProgram = "hap.py";
  };
}
