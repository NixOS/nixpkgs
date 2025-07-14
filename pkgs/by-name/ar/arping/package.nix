{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libnet,
  libpcap,
}:

stdenv.mkDerivation rec {
  pname = "arping";
  version = "2.26";

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = "arping";
    rev = "arping-${version}";
    hash = "sha256-uZsUo12ez6sz95fmOg5cmVBJNRH3eEhio8V2efQ29BU=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libnet
    libpcap
  ];

  meta = with lib; {
    description = "Broadcasts a who-has ARP packet on the network and prints answers";
    homepage = "https://github.com/ThomasHabets/arping";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ michalrus ];
    platforms = platforms.unix;
    mainProgram = "arping";
  };
}
