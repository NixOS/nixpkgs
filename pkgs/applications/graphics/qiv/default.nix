{ stdenv, fetchurl, pkgconfig, gtk, imlib2, file } :

stdenv.mkDerivation (rec {
  name = "qiv-2.2.4";

  src = fetchurl {
    url = "http://spiegl.de/qiv/download/${name}.tgz";
    sha256 = "ed6078dc550c1dc2fe35c1e0f46463c13589a24b83d4f7101b71a7485e51abb7";
  };

  buildInputs = [ pkgconfig gtk imlib2 file ];

  preBuild=''
    substituteInPlace Makefile --replace /usr/local "$out"
    substituteInPlace Makefile --replace /man/ /share/man/
  '';

  meta = {
    description = "qiv (quick image viewer)";
    homepage = http://spiegl.de/qiv/;
  };
})
