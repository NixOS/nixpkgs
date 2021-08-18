{ lib, stdenv, fetchurl, cln, pkg-config, readline, gmp, python3 }:

stdenv.mkDerivation rec {
  name = "ginac-1.8.1";

  src = fetchurl {
    url    = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "sha256-8WldvWsYcGHvP7pQdkjJ1tukOPczsFjBb5J4y9z14as=";
  };

  propagatedBuildInputs = [ cln ];

  buildInputs = [ readline ] ++ lib.optional stdenv.isDarwin gmp;

  nativeBuildInputs = [ pkg-config python3 ];

  strictDeps = true;

  preConfigure = "patchShebangs ginsh";

  configureFlags = [ "--disable-rpath" ];

  meta = with lib; {
    description = "GiNaC is Not a CAS";
    homepage    = "https://www.ginac.de/";
    maintainers = with maintainers; [ lovek323 ];
    license = licenses.gpl2;
    platforms   = platforms.all;
  };
}
