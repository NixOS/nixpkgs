{
  lib,
  stdenv,
  fetchurl,
  cln,
  pkg-config,
  readline,
  gmp,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "ginac";
  version = "1.8.9";

  src = fetchurl {
    url = "https://www.ginac.de/ginac-${version}.tar.bz2";
    sha256 = "sha256-bP1Gz043NpDhLRa3cteu0PXEM9qMfs0kd/LnNkg7tDk=";
  };

  propagatedBuildInputs = [ cln ];

  buildInputs = [ readline ] ++ lib.optional stdenv.hostPlatform.isDarwin gmp;

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  strictDeps = true;

  preConfigure = ''
    patchShebangs ginsh
  '';

  configureFlags = [ "--disable-rpath" ];

  meta = with lib; {
    description = "GiNaC C++ library for symbolic manipulations";
    homepage = "https://www.ginac.de/";
    maintainers = with maintainers; [ lovek323 ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
