{ stdenv, fetchhg, pidgin, glib, json_glib, protobuf, protobufc }:

stdenv.mkDerivation rec {
  name = "purple-hangouts-hg-${version}";
  version = "2016-08-31";

  src = fetchhg {
    url = "https://bitbucket.org/EionRobb/purple-hangouts/";
    rev = "1c0286e48e92";
    sha256 = "0iv1isa8brm89nvmwrvxjm5ymx4svqrz3gf5yciqzf6kpc82gnxr";
  };

  buildInputs = [ pidgin glib json_glib protobuf protobufc ];

  installPhase = ''
    install -Dm755 -t $out/lib/pidgin/ libhangouts.so
    for size in 16 22 24 48; do
      install -TDm644 hangouts$size.png $out/pixmaps/pidgin/protocols/$size/hangouts.png
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/EionRobb/purple-hangouts;
    description = "Native Hangouts support for pidgin";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ralith ];
  };
}
