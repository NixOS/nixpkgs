{
  stdenv,
  lib,
  fetchurl,
  python3Packages,
  cmake,
  python3,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "obitools3";
  version = "3.0.1b11";
  format = "setuptools";

  src = fetchurl {
    url = "https://git.metabarcoding.org/obitools/obitools3/repository/v${finalAttrs.version}/archive.tar.gz";
    sha256 = "1x7a0nrr9agg1pfgq8i1j8r1p6c0jpyxsv196ylix1dd2iivmas1";
  };

  nativeBuildInputs = [
    python3Packages.cython
    cmake
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    substituteInPlace setup.py \
    --replace "'-msse2'," ""
  '';

  preBuild = ''
    substituteInPlace src/CMakeLists.txt --replace \$'{PYTHONLIB}' "$out/${python3.sitePackages}";
    export NIX_CFLAGS_COMPILE="-L $out/${python3.sitePackages} $NIX_CFLAGS_COMPILE"
  '';

  dontConfigure = true;

  doCheck = true;

  meta = {
    description = "Management of analyses and data in DNA metabarcoding";
    mainProgram = "obi";
    homepage = "https://git.metabarcoding.org/obitools/obitools3";
    license = lib.licenses.cecill20;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.all;
  };
})
