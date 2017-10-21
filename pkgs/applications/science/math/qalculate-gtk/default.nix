{ stdenv, fetchurl, intltool, autoreconfHook, pkgconfig, libqalculate, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "qalculate-gtk-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/Qalculate/qalculate-gtk/archive/v${version}.tar.gz";
    sha256 = "14q89l6laa7v7d9qx7v71a0r2m65saxqgr9r871fasm400a9x8pw";
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
