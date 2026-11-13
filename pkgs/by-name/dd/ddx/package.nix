{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
  meson,
  ninja,
  pkg-config,
  blas,
  lapack,
  python3,
}:

assert !(blas.isILP64);
assert !(lapack.isILP64);

stdenv.mkDerivation (finalAttrs: {
  pname = "ddx";
  version = "1.0.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ddsolvation";
    repo = "ddX";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JPqeDtHhN7bBHbSZ9UFnoBNm+RvmaWptzXBeDvifFl4=";
  };

  postPatch = ''
    patchShebangs --build config/install-mod.py
  '';

  nativeBuildInputs = [
    gfortran
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    blas
    lapack
  ];

  mesonFlags = [
    "-Dtests=false"
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = false;

  meta = {
    description = "Fast continuum solvation based on domain decomposition";
    mainProgram = "ddX_exec";
    license = lib.licenses.lgpl3Plus;
    homepage = "https://github.com/ddsolvation/ddX";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
