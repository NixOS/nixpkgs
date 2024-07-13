{ lib, stdenv, fetchurl, ocaml }:

stdenv.mkDerivation (finalAttrs: {
  pname = "cryptoverif";
  version = "2.09";

  src = fetchurl {
    url    = "http://prosecco.gforge.inria.fr/personal/bblanche/cryptoverif/cryptoverif${finalAttrs.version}.tar.gz";
    hash = "sha256-FJlPZgTUZ+6HzhG/B0dOiVIjDvoCnF6yg2E9UriSojw=";
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
    mainProgram = "cryptoverif";
    homepage    = "https://prosecco.gforge.inria.fr/personal/bblanche/cryptoverif/";
    license     = lib.licenses.cecill-b;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
})
