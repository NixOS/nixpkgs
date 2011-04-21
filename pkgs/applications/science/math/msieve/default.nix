{stdenv, fetchurl, zlib, gmp}:

stdenv.mkDerivation {
  name = "msieve-1.48";

  src = fetchurl {
      url = mirror://sourceforge/msieve/msieve/Msieve%20v1.48/msieve148.tar.gz;
      sha256 = "05cm23mpfsbwssqda243sbi8m31j783qx89x9gl7sy8a4dnv7h63";
    };

  buildInputs = [ zlib gmp ];

  buildFlags = if stdenv.system == "x86_64-linux" then "x86_64"
               else if stdenv.system == "i686-linux" then "x86"
               else "generic";

  installPhase = ''ensureDir $out/bin/
                   cp msieve $out/bin/'';

  meta = {
    description = "a C library implementing a suite of algorithms to factor large integers";
    license = stdenv.lib.licenses.publicDomain;
    homepage = http://msieve.sourceforge.net/;
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
