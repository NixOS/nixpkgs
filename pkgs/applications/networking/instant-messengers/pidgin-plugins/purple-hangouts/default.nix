{ stdenv, fetchhg, pidgin, glib, json_glib, protobuf, protobufc }:

stdenv.mkDerivation rec {
  name = "purple-hangouts-hg-${version}";
  version = "2016-12-22";

  src = fetchhg {
    url = "https://bitbucket.org/EionRobb/purple-hangouts/";
    rev = "754e3bb971cfe913b90c7fd028fe47a42f9e83cb";
    sha256 = "0b826hj5jgfdckzh9wyycxxhpyxhrhxm3n0mhaf3f57gqarriics";
  };

  buildInputs = [ pidgin glib json_glib protobuf protobufc ];

  installPhase = ''
    install -Dm755 -t $out/lib/pidgin/ libhangouts.so
    for size in 16 22 24 48; do
      install -TDm644 hangouts$size.png $out/share/pixmaps/pidgin/protocols/$size/hangouts.png
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
