{ stdenv, fetchurl, pkgconfig, libbsd, ncurses, buildPackages }:

stdenv.mkDerivation rec {
  pname = "mg";
  version = "20171014";

  src = fetchurl {
    url = "http://homepage.boetes.org/software/mg/${pname}-${version}.tar.gz";
    sha256 = "0hakfikzsml7z0hja8m8mcahrmfy2piy81bq9nccsjplyfc9clai";
  };

  enableParallelBuilding = true;

  makeFlags = [ "PKG_CONFIG=${buildPackages.pkgconfig}/bin/pkg-config" ];

  installPhase = ''
    install -m 555 -Dt $out/bin mg
    install -m 444 -Dt $out/share/man/man1 mg.1
  '';

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libbsd ncurses ];

  meta = with stdenv.lib; {
    description = "Micro GNU/emacs, a portable version of the mg maintained by the OpenBSD team";
    homepage = "https://homepage.boetes.org/software/mg";
    license = licenses.publicDomain;
    platforms = platforms.all;
  };
}
