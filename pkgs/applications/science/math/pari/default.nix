{ stdenv, fetchurl
, gmp, readline, libX11, libpthreadstubs, tex, perl }:

stdenv.mkDerivation rec {

  name = "pari-${version}";
  version = "2.9.0";

  src = fetchurl {
    url = "http://pari.math.u-bordeaux.fr/pub/pari/unix/${name}.tar.gz";
    sha256 = "0rljznrvjgy71n4hlpgx1l1yy1qx52mly68k3c05ds21mlvzg92a";
  };

  buildInputs = [ gmp readline libX11 libpthreadstubs tex perl ];

  configureScript = "./Configure";
  configureFlags =
    "--mt=pthread" +
    "--with-gmp=${gmp.dev} " +
    "--with-readline=${readline.dev}";

  makeFlags = "all";

  meta = with stdenv.lib; {
    description = "Computer algebra system for high-performance number theory computations";
    longDescription = ''
       PARI/GP is a widely used computer algebra system designed for fast
       computations in number theory (factorizations, algebraic number theory,
       elliptic curves...), but also contains a large number of other useful
       functions to compute with mathematical entities such as matrices,
       polynomials, power series, algebraic numbers etc., and a lot of
       transcendental functions. PARI is also available as a C library to allow
       for faster computations.

       Originally developed by Henri Cohen and his co-workers (Université
       Bordeaux I, France), PARI is now under the GPL and maintained by Karim
       Belabas with the help of many volunteer contributors.

       - PARI is a C library, allowing fast computations.  
       - gp is an easy-to-use interactive shell giving access to the
          PARI functions.
       - GP is the name of gp's scripting language.
       - gp2c, the GP-to-C compiler, combines the best of both worlds 
          by compiling GP scripts to the C language and transparently loading 
          the resulting functions into gp. (gp2c-compiled scripts will typically
          run 3 or 4 times faster.) gp2c currently only understands a subset
           of the GP language.
    '';
    homepage    = "http://pari.math.u-bordeaux.fr/";
    downloadPage = "http://pari.math.u-bordeaux.fr/download.html";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ ertes raskin AndersonTorres ];
    platforms   = platforms.linux;
    updateWalker = true;
  };
}
