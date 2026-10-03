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
    hash = "sha256-S0s2sngKeVBZ6m+HIKRVm8RxQvOrJIx207L6+atXfI4=";
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
    maintainers = [ ];
  };
}
