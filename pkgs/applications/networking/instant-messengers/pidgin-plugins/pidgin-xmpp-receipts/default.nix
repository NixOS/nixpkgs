{ stdenv, fetchFromGitHub, pidgin } :

let
  version = "0.7";
in
stdenv.mkDerivation rec {
  name = "pidgin-xmpp-receipts-${version}";

  src = fetchFromGitHub {
    owner = "noonien-d";
    repo = "pidgin-xmpp-receipts";
    rev = "release_${version}";
    sha256 = "1ackqwsqgy1nfggl9na4jicv7hd542aazkg629y2jmbyj1dl3kjm";
  };

  buildInputs = [ pidgin ];

  installPhase = ''
    mkdir -p $out/lib/pidgin/
    cp xmpp-receipts.so $out/lib/pidgin/
  '';

  meta = with stdenv.lib; {
    homepage = http://devel.kondorgulasch.de/pidgin-xmpp-receipts/;
    description = "Message delivery receipts (XEP-0184) Pidgin plugin";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
