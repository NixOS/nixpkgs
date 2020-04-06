{ stdenv, fetchFromGitHub, libroxml, proj, libyamlcpp, boost } :

stdenv.mkDerivation rec {
  pname = "osm2xmap";
  version = "2.0";

  src = fetchFromGitHub {
    sha256 = "1d3f18wzk240yp0q8i2vskhcfj5ar61s4hw83vgps0wr2aglph3w";
    repo = "osm2xmap";
    owner = "sembruk";
    rev = "v${version}";
  };

  makeFlags = [
    "GIT_VERSION=${version}"
    "GIT_TIMESTAMP="
    "SHAREDIR=${placeholder ''out''}/share/osm2xmap"
    "INSTALL_BINDIR=${placeholder ''out''}/bin"
    "INSTALL_MANDIR=${placeholder ''out''}/share/man/man1"
  ];

  NIX_CFLAGS_COMPILE = "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H";

  buildInputs = [ libroxml proj libyamlcpp boost ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sembruk/osm2xmap";
    description = "Converter from OpenStreetMap data format to OpenOrienteering Mapper format.";
    license = licenses.gpl3;
    maintainers = [ maintainers.mpickering ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
