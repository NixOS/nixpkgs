{stdenv, fetchurl, gmp}:

let
  pname = "ecm";
  version = "6.2.3";
  name = "${pname}-${version}";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
      url = https://gforge.inria.fr/frs/download.php/22124/ecm-6.2.3.tar.gz;
      sha256 = "1iwwhbz5vwl7j6dyh292hahc8yy16pq9mmm7mxy49zhxd81vy08p";
    };

  buildInputs = [ gmp ];

  doCheck = true;

  meta = {
    description = "Elliptic Curve Method for Integer Factorization";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://ecm.gforge.inria.fr/;
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
