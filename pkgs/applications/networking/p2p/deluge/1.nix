{ stdenv, fetchurl, fetchpatch, intltool, libtorrent-rasterbar, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  pname = "deluge";
  version = "1.3.15";

  src = fetchurl {
    url = "http://download.deluge-torrent.org/source/${pname}-${version}.tar.bz2";
    sha256 = "1467b9hmgw59gf398mhbf40ggaka948yz3afh6022v753c9j7y6w";
  };

  patches = [
    # Fix preferences when built against libtorrent >=0.16
    (fetchpatch {
      url = "https://git.deluge-torrent.org/deluge/patch/?id=38d7b7cdfde3c50d6263602ffb03af92fcbfa52e";
      sha256 = "0la3i0lkj6yv4725h4kbd07mhfwcb34w7prjl9gxg12q7px6c31d";
    })
  ];

  propagatedBuildInputs = with pythonPackages; [
    pyGtkGlade twisted Mako chardet pyxdg pyopenssl service-identity
    libtorrent-rasterbar.dev libtorrent-rasterbar.python setuptools
  ];

  nativeBuildInputs = [ intltool ];

  postInstall = ''
     mkdir -p $out/share/applications
     cp -R deluge/data/pixmaps $out/share/
     cp -R deluge/data/icons $out/share/
     cp deluge/data/share/applications/deluge.desktop $out/share/applications
  '';

  meta = with stdenv.lib; {
    homepage = "https://deluge-torrent.org";
    description = "Torrent client";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ domenkozar ebzzry ];
    broken = stdenv.isDarwin;
    platforms = platforms.all;
  };
}
