{ stdenv, fetchurl, intltool, libtorrentRasterbar, pythonPackages }:
pythonPackages.buildPythonPackage rec {
  name = "deluge-${version}";
  version = "1.3.15";

  src = fetchurl {
    url = "http://download.deluge-torrent.org/source/${name}.tar.bz2";
    sha256 = "1467b9hmgw59gf398mhbf40ggaka948yz3afh6022v753c9j7y6w";
  };

  propagatedBuildInputs = with pythonPackages; [
    pyGtkGlade libtorrentRasterbar twisted Mako chardet pyxdg pyopenssl service-identity
  ];

  nativeBuildInputs = [ intltool ];

  postInstall = ''
     mkdir -p $out/share/applications
     cp -R deluge/data/pixmaps $out/share/
     cp -R deluge/data/icons $out/share/
     cp deluge/data/share/applications/deluge.desktop $out/share/applications
  '';

  meta = with stdenv.lib; {
    homepage = http://deluge-torrent.org;
    description = "Torrent client";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ domenkozar ebzzry ];
    platforms = platforms.all;
  };
}
