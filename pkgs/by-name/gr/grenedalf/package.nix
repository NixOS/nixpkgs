{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  autoconf,
  pkg-config,
  libz,
  bzip2,
  xz,
  libdeflate,
  htslib,
  fetchurl,
}:

let
  # Grenedalf is binded to htslib 1.16 and does not link with libcurl
  htslib_gr = htslib.overrideDerivation (oldAttrs: rec {
    version = "1.16";
    name = "${oldAttrs.pname}-nocurl-${version}";
    src = fetchurl {
      url = "https://github.com/samtools/htslib/releases/download/${version}/htslib-${version}.tar.bz2";
      sha256 = "sha256-YGt8ev9zc0zwM+zRVvQFKfpXkvVFJJUqKJOMoIkNeSQ=";
    };
    configureFlags = [
      "--disable-libcurl"
      "--disable-plugins"
    ];
    # Patches break the build
    patches = [ ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "grenedalf";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "lczech";
    repo = "grenedalf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RD2WYhGBPJuBmbqrjDqujKj/djnxA5ED/LFmhHYIFyE=";
    fetchSubmodules = true;
  };

  patches = [
    ./fix-genesis-cmake.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 2.8.12 FATAL_ERROR)" "cmake_minimum_required (VERSION 3.5 FATAL_ERROR)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    autoconf
  ];

  buildInputs = [
    libz
    bzip2
    xz
    libdeflate
    htslib_gr
  ];

  cmakeFlags = [
    "-DHTSLIB_DIR=${htslib_gr}"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ../bin/grenedalf $out/bin

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/lczech/grenedalf";
    description = "Collection of commands for working with population genetic data";
    longDescription = ''
      grenedalf is a collection of commands for working with population genetic
      data, in particular from pool sequencing. Its main focus are statistical
      analyses such as Tajima's D and Fst. The statistics follow the approaches
      of PoPoolation and PoPoolation2, as well as poolfstat and npstat. However,
      compared to those, grenedalf is significantly more scalable, more user
      friendly, and offers more settings and input file formats.
    '';
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bzizou ];
  };
})
