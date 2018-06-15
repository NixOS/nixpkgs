{ stdenv, fetchhg, pidgin, glib, json-glib, protobuf, protobufc }:

stdenv.mkDerivation rec {
  name = "purple-hangouts-hg-${version}";
  version = "2018-03-28";

  src = fetchhg {
    url = "https://bitbucket.org/EionRobb/purple-hangouts/";
    rev = "0e137e6bf9e95c5a0bd282f3ad4a5bd00a6968ab";
    sha256 = "04vjgz6qyd9ilv1c6n08r45vc683vxs1rgfwhh65pag6q4rbzlb9";
  };

  buildInputs = [ pidgin glib json-glib protobuf protobufc ];

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
