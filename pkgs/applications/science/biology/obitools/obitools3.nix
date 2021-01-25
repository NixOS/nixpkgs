{ lib, fetchurl, python3Packages, cmake, python3 }:

let
  pythonPackages = python3Packages;
in

pythonPackages.buildPythonApplication rec {
  pname = "obitools3";
  version = "3.0.0-beta14";

  src = fetchurl {
    url = "https://git.metabarcoding.org/obitools/${pname}/repository/v${version}/archive.tar.gz";
    sha256 = "17krklxfvxl6baf2m394gm1a88y0lg0bwqx20cf5q39zyw04z442";
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
