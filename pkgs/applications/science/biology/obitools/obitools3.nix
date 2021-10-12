{ lib, fetchurl, python3Packages, cmake, python3 }:

let
  pythonPackages = python3Packages;
in

pythonPackages.buildPythonApplication rec {
  pname = "obitools3";
  version = "3.0.1b11";

  src = fetchurl {
    url = "https://git.metabarcoding.org/obitools/${pname}/repository/v${version}/archive.tar.gz";
    sha256 = "1x7a0nrr9agg1pfgq8i1j8r1p6c0jpyxsv196ylix1dd2iivmas1";
  };

  preBuild = ''
    substituteInPlace src/CMakeLists.txt --replace \$'{PYTHONLIB}' "$out/lib/${python3.libPrefix}/site-packages";
    export NIX_CFLAGS_COMPILE="-L $out/lib/${python3.libPrefix}/site-packages $NIX_CFLAGS_COMPILE"
  '';

  disabled = !pythonPackages.isPy3k;

  nativeBuildInputs = [ pythonPackages.cython cmake ];

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
