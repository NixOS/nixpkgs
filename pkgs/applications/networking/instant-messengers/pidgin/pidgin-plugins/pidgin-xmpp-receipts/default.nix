{
  lib,
  stdenv,
  fetchFromGitHub,
  pidgin,
}:

let
  version = "0.8";
in
stdenv.mkDerivation {
  pname = "pidgin-xmpp-receipts";
  inherit version;

  src = fetchFromGitHub {
    owner = "noonien-d";
    repo = "pidgin-xmpp-receipts";
    rev = "release_${version}";
    sha256 = "13kwaymzkymjsdv8q95byd173i4vanj211vgx9cm0y8ag2r3cjsb";
  };

  buildInputs = [ pidgin ];

  installPhase = ''
    mkdir -p $out/lib/pidgin/
    cp xmpp-receipts.so $out/lib/pidgin/
  '';

  meta = {
    homepage = "http://devel.kondorgulasch.de/pidgin-xmpp-receipts/";
    description = "Message delivery receipts (XEP-0184) Pidgin plugin";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ orivej ];
  };
}
