{ stdenv
, fetchurl
, gmp
, readline
, libX11
, tex
, perl
, withThread ? true, libpthreadstubs
}:

assert withThread -> libpthreadstubs != null;

stdenv.mkDerivation rec {
  pname = "pari";
  version = "2.11.4";

  src = fetchurl {
    # Versions with current majorMinor values are at http://pari.math.u-bordeaux.fr/pub/pari/unix/${pname}-${version}.tar.gz
    url = "https://pari.math.u-bordeaux.fr/pub/pari/OLD/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-v8iPxPc1L0hA5uNSxy8DacvqikVAOxg0piafNwmXCxw=";
  };

  buildInputs = [
    gmp
    readline
    libX11
    tex
    perl
  ] ++ stdenv.lib.optionals withThread [
    libpthreadstubs
  ];

  configureScript = "./Configure";
  configureFlags = [
    "--with-gmp=${gmp.dev}"
    "--with-readline=${readline.dev}"
  ] ++ stdenv.lib.optional stdenv.isDarwin "--host=x86_64-darwin"
  ++ stdenv.lib.optional withThread "--mt=pthread";

  preConfigure = ''
    export LD=$CC
  '';

  postConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    echo 'echo x86_64-darwin' > config/arch-osname
  '';

  makeFlags = [ "all" ];

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
       - gp is an easy-to-use interactive shell giving access to the PARI
         functions.
       - GP is the name of gp's scripting language.
       - gp2c, the GP-to-C compiler, combines the best of both worlds by
         compiling GP scripts to the C language and transparently loading the
         resulting functions into gp. (gp2c-compiled scripts will typically run
         3 or 4 times faster.) gp2c currently only understands a subset of the
         GP language.
    '';
    homepage = "http://pari.math.u-bordeaux.fr";
    downloadPage = "http://pari.math.u-bordeaux.fr/download.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ertes AndersonTorres ] ++ teams.sage.members;
    platforms = platforms.linux ++ platforms.darwin;
    updateWalker = true;
  };
}
