{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  blas,
  # Check Inputs
  python3,
}:

stdenv.mkDerivation rec {
  pname = "libcint";
  version = "6.1.3";

  src = fetchFromGitHub {
    owner = "sunqm";
    repo = "libcint";
    rev = "v${version}";
    hash = "sha256-k9luTarszZAqh33SzPMM3BYj01HT7cfTipt44nSC+2A=";
  };

  postPatch = ''
    sed -i 's/libcint.so/libcint${stdenv.hostPlatform.extensions.sharedLibrary}/g' testsuite/*.py
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ blas ];
  cmakeFlags = [
    "-DENABLE_TEST=1"
    "-DQUICK_TEST=1"
    "-DCMAKE_INSTALL_PREFIX=" # ends up double-adding /nix/store/... prefix, this avoids issue
    "-DWITH_RANGE_COULOMB:STRING=1"
    "-DWITH_FORTRAN:STRING=1"
    "-DMIN_EXPCUTOFF:STRING=20"
  ];

  strictDeps = true;

  doCheck = true;
  nativeCheckInputs = [ python3.pkgs.numpy ];

  meta = with lib; {
    description = "General GTO integrals for quantum chemistry";
    longDescription = ''
      libcint is an open source library for analytical Gaussian integrals.
      It provides C/Fortran API to evaluate one-electron / two-electron
      integrals for Cartesian / real-spheric / spinor Gaussian type functions.
    '';
    homepage = "http://wiki.sunqm.net/libcint";
    downloadPage = "https://github.com/sunqm/libcint";
    changelog = "https://github.com/sunqm/libcint/blob/master/ChangeLog";
    license = licenses.bsd2;
    maintainers = with maintainers; [ drewrisinger ];
    platforms = platforms.unix;
  };
}
