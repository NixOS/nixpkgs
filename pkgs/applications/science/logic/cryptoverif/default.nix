{ stdenv, fetchurl, ocaml }:

stdenv.mkDerivation rec {
  name = "cryptoverif-${version}";
  version = "2.00";

  src = fetchurl {
    url    = "http://prosecco.gforge.inria.fr/personal/bblanche/cryptoverif/cryptoverif${version}.tar.gz";
    sha256 = "0g8pkj58b48zk4c0sgpln0qhbj82v75mz3w6cl3w5bvmxsbkwvy1";
  };

  buildInputs = [ ocaml ];

  /* Fix up the frontend to load the 'default' cryptoverif library
  ** from under $out/libexec. By default, it expects to find the files
  ** in $CWD which doesn't work. */
  patchPhase = ''
    substituteInPlace ./src/settings.ml \
      --replace \"default\" \"$out/libexec/default\"
  '';

  buildPhase = "./build";
  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp ./cryptoverif   $out/bin
    cp ./default.cvl   $out/libexec
    cp ./default.ocvl  $out/libexec
  '';

  meta = {
    description = "Cryptographic protocol verifier in the computational model";
    homepage    = "https://prosecco.gforge.inria.fr/personal/bblanche/cryptoverif/";
    license     = stdenv.lib.licenses.cecill-b;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
