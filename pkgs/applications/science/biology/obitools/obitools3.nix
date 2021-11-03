{ stdenv, lib, fetchurl, python3Packages, cmake, python3 }:

python3Packages.buildPythonApplication rec {
  pname = "obitools3";
  version = "3.0.1b11";

  src = fetchurl {
    url = "https://git.metabarcoding.org/obitools/${pname}/repository/v${version}/archive.tar.gz";
    sha256 = "1x7a0nrr9agg1pfgq8i1j8r1p6c0jpyxsv196ylix1dd2iivmas1";
  };

  disabled = python3Packages.pythonOlder "3.5";

  nativeBuildInputs = [ python3Packages.cython cmake ];

  postPatch = lib.optionalString stdenv.isAarch64 ''
      substituteInPlace setup.py \
      --replace "'-msse2'," ""
  '';

  preBuild = ''
    substituteInPlace src/CMakeLists.txt --replace \$'{PYTHONLIB}' "$out/lib/${python3.libPrefix}/site-packages";
    export NIX_CFLAGS_COMPILE="-L $out/lib/${python3.libPrefix}/site-packages $NIX_CFLAGS_COMPILE"
  '';

  dontConfigure = true;

  doCheck = true;

  meta = with lib ; {
    description = "Management of analyses and data in DNA metabarcoding";
    homepage = "https://git.metabarcoding.org/obitools/obitools3";
    license = licenses.cecill20;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.all;
  };
}
