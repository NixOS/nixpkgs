{ stdenv, fetchurl, intltool, autoreconfHook, pkgconfig, libqalculate, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "qalculate-gtk-${version}";
  version = "2.0.0a";

  src = fetchurl {
    url = "https://github.com/Qalculate/qalculate-gtk/archive/v${version}.tar.gz";
    sha256 = "0bif79wl2hi0sf4pk2b4s2xz33lj7401pygsdmxrnr5gqqq0s696";
  };

  patchPhase = ''
    substituteInPlace src/main.cc --replace 'getPackageDataDir().c_str()' \"$out/share\"
  '';

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ intltool pkgconfig autoreconfHook wrapGAppsHook ];
  buildInputs = [ libqalculate gtk3 ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The ultimate desktop calculator";
    homepage = http://qalculate.github.io;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
