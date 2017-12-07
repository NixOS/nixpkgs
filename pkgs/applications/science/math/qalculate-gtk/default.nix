{ stdenv, fetchurl, intltool, autoreconfHook, pkgconfig, libqalculate, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "qalculate-gtk-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/Qalculate/qalculate-gtk/archive/v${version}.tar.gz";
    sha256 = "08sg6kfcfdpxjsl538ba26ncm2cxzc63nlafj99ff4b46wxia57k";
  };

  patchPhase = ''
    for fn in src/interface.cc src/main.cc; do
      substituteInPlace $fn --replace 'getPackageDataDir().c_str()' \"$out/share\"
    done
  '';

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ intltool pkgconfig autoreconfHook wrapGAppsHook ];
  buildInputs = [ libqalculate gtk3 ];

  meta = with stdenv.lib; {
    description = "The ultimate desktop calculator";
    homepage = http://qalculate.github.io;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
