{ stdenv, fetchhg, pidgin, glib, json-glib, protobuf, protobufc }:

stdenv.mkDerivation rec {
  name = "purple-hangouts-hg-${version}";
  version = "2018-12-02";

  src = fetchhg {
    url = "https://bitbucket.org/EionRobb/purple-hangouts/";
    rev = "cccf2f6";
    sha256 = "1zd1rlzqvw1zkb0ydyz039n3xa1kv1f20a4l6rkm9a8sp6rpf3pi";
  };

  buildInputs = [ pidgin glib json-glib protobuf protobufc ];

  PKG_CONFIG_PURPLE_PLUGINDIR = "${placeholder "out"}/lib/purple-2";
  PKG_CONFIG_PURPLE_DATADIR = "${placeholder "out"}/share";

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/EionRobb/purple-hangouts;
    description = "Native Hangouts support for pidgin";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ralith ];
  };
}
