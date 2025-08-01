{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "scheme48";
  version = "1.9.3";

  src = fetchurl {
    url = "https://s48.org/${version}/scheme48-${version}.tgz";
    sha256 = "bvWp8/yhQRCw+DG0WAHRH5vftnmdl2qhLk+ICdrzkEw=";
  };

  # Make more reproducible by removing build user and date.
  postPatch = ''
    substituteInPlace build/build-usual-image --replace '"(made by $USER on $date)"' '""'
  '';

  # Silence warnings related to use of implicitly declared library functions and implicit ints.
  # TODO: Remove and/or fix with patches the next time this package is updated.
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=implicit-int"
    ];
  };

  # Don't build or install documentation, which depends on pdflatex,
  # tex2page, and probably other things for which there is no nixpkgs
  # derivation available
  buildPhase = ''
    runHook preBuild
    make vm image libscheme48 script-interpreter go
    runHook postBuild
  '';
  installTargets = "install-no-doc";

  meta = with lib; {
    homepage = "https://s48.org/";
    description = "Scheme 48 interpreter for R5RS";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = [ maintainers.siraben ];
  };
}
