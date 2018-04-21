{ stdenv, fetchgit, pkgconfig, pidgin, json-glib, glib, http-parser } :

let
  version = "2016-07-11";
in
stdenv.mkDerivation rec {
  name = "purple-matrix-unstable-${version}";

  src = fetchgit {
    url = "https://github.com/matrix-org/purple-matrix";
    rev = "f9d36198a57de1cd1740a3ae11c2ad59b03b724a";
    sha256 = "1mmyvc70gslniphmcpk8sfl6ylik6dnprqghx4n47gsj1sb1cy00";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pidgin json-glib glib http-parser ];

  installPhase = ''
    install -Dm755 -t $out/lib/pidgin/ libmatrix.so
    for size in 16 22 48; do
      install -TDm644 matrix-"$size"px.png $out/pixmaps/pidgin/protocols/$size/matrix.png
    done
  '';

  meta = {
    homepage = https://github.com/matrix-org/purple-matrix;
    description = "Matrix support for Pidgin / libpurple";
    license = stdenv.lib.licenses.gpl2;
  };
}
