{ stdenv, fetchhg, pidgin, glib, json-glib, protobuf, protobufc }:

stdenv.mkDerivation rec {
  name = "purple-hangouts-hg-${version}";
  version = "2017-10-08";

  src = fetchhg {
    url = "https://bitbucket.org/EionRobb/purple-hangouts/";
    rev = "5e769791d282a6e5ae4d94dc66a1ff9d6904ec9c";
    sha256 = "0cs7dcd44lkc2anradyddjvmfvnl46ixw4idaf1m9fd7j35mg7b1";
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
