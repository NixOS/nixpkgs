{ stdenv, fetchFromGitHub, libroxml, proj, libyamlcpp, boost } :

stdenv.mkDerivation rec {
  name = "osm2xmap-${version}";
  version = "2.0";

  src = fetchFromGitHub {
    sha256 = "1d3f18wzk240yp0q8i2vskhcfj5ar61s4hw83vgps0wr2aglph3w";
    repo = "osm2xmap";
    owner = "sembruk";
    rev = "v${version}";
  };

  makeFlags = [
    "GIT_VERSION=$(version)"
    "GIT_TIMESTAMP="
    "SHAREDIR=$(out)/share/"
    "INSTALL_BINDIR=$(out)/bin"
    "INSTALL_MANDIR=$(out)/share/man/man1"
    "INSTALL_SHAREDIR=$(out)/share/"
  ];

  NIX_CFLAGS_COMPILE = [ "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H" ];

  installFlags = [ "DESTDIR=$(out)" ];

  buildInputs = [ libroxml proj libyamlcpp boost ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sembruk/osm2xmap";
    description = "Converter from OpenStreetMap data format to OpenOrienteering Mapper format.";
    license = licenses.gpl3;
    maintainers = [ maintainers.mpickering ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
