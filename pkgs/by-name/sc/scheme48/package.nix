{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "scheme48";
  version = "1.9.2";

  src = fetchurl {
    url = "https://s48.org/${version}/scheme48-${version}.tgz";
    sha256 = "1x4xfm3lyz2piqcw1h01vbs1iq89zq7wrsfjgh3fxnlm1slj2jcw";
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

  meta = with lib; {
    homepage = "https://s48.org/";
    description = "Scheme 48 interpreter for R5RS";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = [ maintainers.siraben ];
  };
}
