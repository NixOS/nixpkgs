{
  lib,
  stdenv,
  fetchurl,
  boost,
  lhapdf,
  ncurses,
  perl,
  python ? null,
  swig,
  yoda,
  zlib,
  withPython ? false,
}:

stdenv.mkDerivation rec {
  pname = "fastnlo-toolkit";
  version = "2.5.0-2826";

  src = fetchurl {
    url = "https://fastnlo.hepforge.org/code/v25/fastnlo_toolkit-${version}.tar.gz";
    hash = "sha256-7aIMYCOkHC/17CHYiEfrxvtSJxTDivrS7BQ32cGiEy0=";
  };

  postPatch = ''
    substituteInPlace py-compile \
      --replace-fail "import sys, os, py_compile, imp" "import sys, os, py_compile, importlib" \
      --replace-fail "imp." "importlib." \
      --replace-fail "hasattr(imp" "hasattr(importlib"
  '';

  patches = [
    # Compatibility with YODA 2.x
    ./yoda2_support.patch
  ];

  nativeBuildInputs = [
    lhapdf # lhapdf-config
    yoda # yoda-config
  ]
  ++ lib.optional withPython python;

  buildInputs = [
    boost
    lhapdf
    yoda
  ]
  ++ lib.optional withPython python
  ++ lib.optional (withPython && python.isPy3k) ncurses;

  propagatedNativeBuildInputs = lib.optional withPython [ swig ];
  propagatedBuildInputs = [
    zlib
  ]
  ++ lib.optional withPython [
    python.pkgs.distutils
  ];

  preConfigure = ''
    substituteInPlace ./fastnlotoolkit/Makefile.in \
      --replace "-fext-numeric-literals" ""

    # disable test that fails due to strict floating-point number comparison
    echo "#!/usr/bin/env perl" > check/fnlo-tk-stattest.pl.in
    chmod +x check/fnlo-tk-stattest.pl.in
  '';

  configureFlags = [
    "--with-yoda=${yoda}"
  ]
  ++ lib.optional withPython "--enable-pyext";

  strictDeps = true;

  enableParallelBuilding = true;

  doCheck = true;
  nativeCheckInputs = [
    perl
    lhapdf.pdf_sets.CT10nlo
  ];
  preCheck = ''
    patchShebangs --build check
  '';
  enableParallelChecking = false;

  # None of our currently packaged versions of swig are C++17-friendly
  # Use a workaround from https://github.com/swig/swig/issues/1538
  env.CXXFLAGS = "-D_LIBCPP_ENABLE_CXX17_REMOVED_FEATURES";

  meta = with lib; {
    homepage = "http://fastnlo.hepforge.org";
    description = "Fast pQCD calculations for hadron-induced processes";
    longDescription = ''
      The fastNLO project provides computer code to create and evaluate fast
      interpolation tables of pre-computed coefficients in perturbation theory
      for observables in hadron-induced processes.

      This allows fast theory predictions of these observables for arbitrary
      parton distribution functions (of regular shape), renormalization or
      factorization scale choices, and/or values of alpha_s(Mz) as e.g. needed
      in PDF fits or in systematic studies. Very time consuming complete
      recalculations are thus avoided.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ veprbl ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
