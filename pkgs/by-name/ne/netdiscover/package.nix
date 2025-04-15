{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  libnet,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "netdiscover";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "netdiscover-scanner";
    repo = pname;
    tag = version;
    hash = "sha256-LUM6vl6pohrTW3X9c1FaDE7j9mvMuAiDkFBKWc4KZso=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    libpcap
    libnet
  ];

  # Running update-oui-database.sh would probably make the build irreproducible

  meta = with lib; {
    description = "Network address discovering tool, developed mainly for those wireless networks without dhcp server, it also works on hub/switched networks";
    homepage = "https://github.com/netdiscover-scanner/netdiscover";
    changelog = "https://github.com/netdiscover-scanner/netdiscover/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vdot0x23 ];
    platforms = platforms.unix;
    mainProgram = "netdiscover";
  };
}
