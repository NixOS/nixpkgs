{ lib, stdenv, fetchurl, cln, pkg-config, readline, gmp, python3 }:

stdenv.mkDerivation rec {
  pname = "ginac";
  version = "1.8.5";

  src = fetchurl {
    url = "https://www.ginac.de/ginac-${version}.tar.bz2";
    sha256 = "sha256-wks3oecJ9mDQl4eH6GszSAPNKOwXaJzzbd/zgAc+omE=";
  };

  propagatedBuildInputs = [ cln ];

  buildInputs = [ readline ]
    ++ lib.optional stdenv.isDarwin gmp;

  nativeBuildInputs = [ pkg-config python3 ];

  strictDeps = true;

  preConfigure = ''
    patchShebangs ginsh
  '';

  configureFlags = [ "--disable-rpath" ];

  meta = with lib; {
    description = "GiNaC is Not a CAS";
    homepage = "https://www.ginac.de/";
    maintainers = with maintainers; [ lovek323 ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
