{ lib, stdenv, fetchurl, ocaml }:

stdenv.mkDerivation rec {
  pname = "cryptoverif";
  version = "2.07";

  src = fetchurl {
    url    = "http://prosecco.gforge.inria.fr/personal/bblanche/cryptoverif/cryptoverif${version}.tar.gz";
    hash   = "sha256-GXXql4+JZ396BM6W2I3kN0u59xos7UCAtzR0IjMIETY=";
  };

  /* Fix up the frontend to load the 'default' cryptoverif library
  ** from under $out/libexec. By default, it expects to find the files
  ** in $CWD which doesn't work. */
  postPatch = ''
    substituteInPlace ./src/syntax.ml \
      --replace \"default\" \"$out/libexec/default\"
  '';

  strictDeps = true;

  nativeBuildInputs = [ ocaml ];

  buildPhase = ''
    runHook preBuild

    ./build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec
    cp ./cryptoverif   $out/bin
    cp ./default.cvl   $out/libexec
    cp ./default.ocvl  $out/libexec

    runHook postInstall
  '';

  meta = {
    description = "Cryptographic protocol verifier in the computational model";
    homepage    = "https://prosecco.gforge.inria.fr/personal/bblanche/cryptoverif/";
    license     = lib.licenses.cecill-b;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
