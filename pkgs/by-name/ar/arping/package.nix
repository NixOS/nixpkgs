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
  version = "2.27";

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = "arping";
    tag = "arping-${version}";
    hash = "sha256-GfIH38LWSayaFXIxi3M3QDkkoYzJoAHMK+hvQgXL1iQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libnet
    libpcap
  ];

  meta = {
    description = "Broadcasts a who-has ARP packet on the network and prints answers";
    homepage = "https://github.com/ThomasHabets/arping";
    changelog = "https://github.com/ThomasHabets/arping/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ michalrus ];
    platforms = lib.platforms.unix;
    mainProgram = "arping";
  };
}
