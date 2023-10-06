{ lib, stdenv, fetchurl, ocaml }:

stdenv.mkDerivation rec {
  pname = "cryptoverif";
  version = "2.05";

  src = fetchurl {
    url    = "http://prosecco.gforge.inria.fr/personal/bblanche/cryptoverif/cryptoverif${version}.tar.gz";
    sha256 = "sha256-F5eVN5ATYo9Ivpi2eYh96ktuTWUeoqgWMR4BqHu8EFs=";
  };

  strictDeps = true;

  nativeBuildInputs = [ ocaml ];

  /* Fix up the frontend to load the 'default' cryptoverif library
  ** from under $out/libexec. By default, it expects to find the files
  ** in $CWD which doesn't work. */
  patchPhase = ''
    substituteInPlace ./src/syntax.ml \
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
    license     = lib.licenses.cecill-b;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
