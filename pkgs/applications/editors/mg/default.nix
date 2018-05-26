{ stdenv, fetchurl, pkgconfig, libbsd, ncurses }:

stdenv.mkDerivation rec {
  name = "mg-${version}";
  version = "20171014";

  src = fetchurl {
    url = "http://homepage.boetes.org/software/mg/${name}.tar.gz";
    sha256 = "0hakfikzsml7z0hja8m8mcahrmfy2piy81bq9nccsjplyfc9clai";
  };

  enableParallelBuilding = true;

  makeFlags = [ "PKG_CONFIG=${pkgconfig}/bin/pkg-config" ];

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
