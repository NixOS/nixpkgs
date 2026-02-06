{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libnet,
  libpcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "arping";
  version = "2.28";

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = "arping";
    tag = "arping-${finalAttrs.version}";
    hash = "sha256-SS4z/aGu1qpTG1k4Cbj1TlC2kHRrP+7HRQyrIX2Xc/E=";
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
    changelog = "https://github.com/ThomasHabets/arping/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ michalrus ];
    platforms = lib.platforms.unix;
    mainProgram = "arping";
  };
})
