{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  libnet,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netdiscover";
  version = "0.21";

  src = fetchFromGitHub {
    owner = "netdiscover-scanner";
    repo = "netdiscover";
    tag = finalAttrs.version;
    hash = "sha256-8m59kdhmH8uxOUCqkvr909DhXDCpMF4grO9ULrrZqjA=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    libpcap
    libnet
  ];

  # Running update-oui-database.sh would probably make the build irreproducible

  meta = {
    description = "Network address discovering tool, developed mainly for those wireless networks without dhcp server, it also works on hub/switched networks";
    homepage = "https://github.com/netdiscover-scanner/netdiscover";
    changelog = "https://github.com/netdiscover-scanner/netdiscover/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ vdot0x23 ];
    platforms = lib.platforms.unix;
    mainProgram = "netdiscover";
  };
})
