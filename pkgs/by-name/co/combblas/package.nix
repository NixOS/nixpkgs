{
  lib,
  fetchurl,
  fetchpatch,
  fetchDebianPatch,
  stdenv,
  fetchFromGitHub,
  cmake,
  mpi,
  mpiCheckPhaseHook,
}:
let
  testdata = fetchurl {
    url = "http://eecs.berkeley.edu/~aydin/CombBLAS_FILES/testdata_combblas1.6.1.tgz";
    hash = "sha256-B9VoPYQ1vxrm/rvwAhID/SNXC7q5xWr/4dwNzwI6wgc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "combblas";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "PASSIONLab";
    repo = "CombBLAS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EANubRd2IZcjFoSJFqm6GoeAeWakI8yOewF7qPClmS4=";
  };

  prePatch = ''
    mkdir build
    tar xzf ${testdata} -C build
  '';

  patches = [
    # These two commits are fetched by debian too
    (fetchpatch {
      url = "https://github.com/PASSIONLab/CombBLAS/commit/eb4811a59a4043a2d0c9d933b71a1e1ef1db287d.patch";
      hash = "sha256-b6boolxY+/eF6C+MgiGecbv0uzEAa85Q08Q2gbQU0EY=";
    })
    (fetchpatch {
      url = "https://github.com/PASSIONLab/CombBLAS/commit/ecf96214a0c666662954cf24b84df97f61d52dc9.patch";
      hash = "sha256-LWuLtSDvVm2NMdDY6RMvPVci6hL4RQaIlMloqRGavnA=";
    })

    (fetchDebianPatch {
      pname = "combblas";
      version = "2.0.0";
      debianRevision = "6";
      patch = "AWPM_library_38dd27e.patch";
      hash = "sha256-T1Oq682z5gK2ZnY+3LBU4vg6ss5bRXleRI3IGT1GP0M=";
    })
    (fetchDebianPatch {
      pname = "combblas";
      version = "2.0.0";
      debianRevision = "6";
      patch = "mpi_build.patch";
      hash = "sha256-EY9rBmbjpm76awLYx7ZKLNbQ7bnMXKCaLmtdI528gsI=";
    })
    ./GraphGenlib_link_math.patch
    # Disable Indexing and SpAsgn test which are reported to fail on Debian and FreeBSD too, See
    # 1. https://github.com/PASSIONLab/CombBLAS/issues/15
    # 2. https://github.com/PASSIONLab/CombBLAS/issues/19
    ./ReleaseTests_CMakeLists.txt.patch
  ];

  nativeBuildInputs = [
    cmake
    mpi
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  doCheck = true;

  nativeCheckInputs = [ mpiCheckPhaseHook ];

  meta = {
    homepage = "https://github.com/PASSIONLab/CombBLAS";
    description = "Extensible distributed-memory parallel graph library";
    changelog = "https://github.com/PASSIONLab/CombBLAS/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      # Files: *
      # Lawrence Berkeley National Labs BSD variant license
      bsd3Lbnl

      # Files: graph500-1.2/*
      # Copyright: 2010, Georgia Institute of Technology, USA
      # Files: psort-1.0/include/psort/MersenneTwister.h
      # Copyright: 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,
      #  2000 - 2003, Richard J. Wagner
      bsd3

      # Files: graph500-1.2/kronecker.*
      # Copyright: 2009-2010 The Trustees of Indiana University.
      boost

      # Files: usort/*
      # Copyright: 2016 Hari Sundar
      # Files: psort-1.0/*
      # Copyright: 2009, David Cheng, Viral Shah <viral@mayin.org>
      mit

      # Files: psort-1.0/include/psort/funnel.* psort-1.0/include/psort/sort.*
      # Copyright: 2005 Kristoffer Vinther
      lgpl2Plus

      # Files: include/Tommy/*
      # Copyright: 2010, Andrea Mazzoleni
      bsd2
    ];
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
