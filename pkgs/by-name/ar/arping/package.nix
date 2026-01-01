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
<<<<<<< HEAD
  version = "2.27";
=======
  version = "2.26";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = "arping";
<<<<<<< HEAD
    tag = "arping-${version}";
    hash = "sha256-GfIH38LWSayaFXIxi3M3QDkkoYzJoAHMK+hvQgXL1iQ=";
=======
    rev = "arping-${version}";
    hash = "sha256-uZsUo12ez6sz95fmOg5cmVBJNRH3eEhio8V2efQ29BU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libnet
    libpcap
  ];

<<<<<<< HEAD
  meta = {
    description = "Broadcasts a who-has ARP packet on the network and prints answers";
    homepage = "https://github.com/ThomasHabets/arping";
    changelog = "https://github.com/ThomasHabets/arping/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ michalrus ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Broadcasts a who-has ARP packet on the network and prints answers";
    homepage = "https://github.com/ThomasHabets/arping";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ michalrus ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "arping";
  };
}
