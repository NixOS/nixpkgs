{ stdenv, fetchurl, pkgconfig, ncurses, buildPackages, libbsd }:

stdenv.mkDerivation rec {
  pname = "mg";
  version = "20180927";

  src = fetchurl {
    url = "https://github.com/hboetes/mg/archive/${version}.tar.gz";
    sha256 = "fbb09729ea00fe42dcdbc96ac7fc1d2b89eac651dec49e4e7af52fad4f5788f6";
  };

  enableParallelBuilding = true;

  makeFlags = [ "PKG_CONFIG=${buildPackages.pkgconfig}/bin/pkg-config" ];

  installPhase = ''
    install -m 555 -Dt $out/bin mg
    install -m 444 -Dt $out/share/man/man1 mg.1
  '';
  nativeBuildInputs = [ pkgconfig ];

  patches = ./darwin_no_libbsd.patch;

  buildInputs = [ ncurses ] ++ stdenv.lib.optional (!stdenv.isDarwin) libbsd;

  meta = with stdenv.lib; {
    description = "Micro GNU/emacs, a portable version of the mg maintained by the OpenBSD team";
    homepage = "https://homepage.boetes.org/software/mg";
    license = licenses.publicDomain;
    platforms = platforms.all;
  };
}
