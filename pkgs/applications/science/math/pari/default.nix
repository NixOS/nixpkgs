{ lib
, stdenv
, fetchurl
, gmp
, libX11
, perl
, readline
, tex
, withThread ? true, libpthreadstubs
}:

assert withThread -> libpthreadstubs != null;

stdenv.mkDerivation rec {
  pname = "pari";
  version = "2.13.4";

  src = fetchurl {
    urls = [
      "https://pari.math.u-bordeaux.fr/pub/pari/unix/${pname}-${version}.tar.gz"
      # old versions are at the url below
      "https://pari.math.u-bordeaux.fr/pub/pari/OLD/${lib.versions.majorMinor version}/${pname}-${version}.tar.gz"
    ];
    hash = "sha256-vN6ezq4VkoFDgcFpfNtwY1Z7ZQQgGxvke7WJIPO84YU=";
  };

  buildInputs = [
    gmp
    libX11
    perl
    readline
    tex
  ] ++ lib.optionals withThread [
    libpthreadstubs
  ];

  configureScript = "./Configure";
  configureFlags = [
    "--with-gmp=${lib.getDev gmp}"
    "--with-readline=${lib.getDev readline}"
  ]
  ++ lib.optional stdenv.isDarwin "--host=x86_64-darwin"
  ++ lib.optional withThread "--mt=pthread";

  preConfigure = ''
    export LD=$CC
  '';

  postConfigure = lib.optionalString stdenv.isDarwin ''
    echo 'echo x86_64-darwin' > config/arch-osname
  '';

  makeFlags = [ "all" ];

  meta = with lib; {
    homepage = "http://pari.math.u-bordeaux.fr";
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
    downloadPage = "http://pari.math.u-bordeaux.fr/download.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ertes AndersonTorres ] ++ teams.sage.members;
    platforms = platforms.linux ++ platforms.darwin;
    broken = stdenv.isDarwin && stdenv.isAarch64;
    mainProgram = "gp";
  };
}
