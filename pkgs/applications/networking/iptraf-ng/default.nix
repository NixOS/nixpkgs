{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  version = "1.2.1";
  pname = "iptraf-ng";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1f91w1bjaayr6ld95z2q55ny983bb0m05k1jrw2bcddvcihaiqb1";
  };

  buildInputs = [ ncurses ];

  makeFlags = [
    "DESTDIR=$(out)"
    "prefix=/usr"
    "sbindir=/bin"
  ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Console-based network monitoring utility (fork of iptraf)";
    longDescription = ''
      IPTraf-ng is a console-based network monitoring utility. IPTraf-ng
      gathers data like TCP connection packet and byte counts, interface
      statistics and activity indicators, TCP/UDP traffic breakdowns, and LAN
      station packet and byte counts. IPTraf-ng features include an IP traffic
      monitor which shows TCP flag information, packet and byte counts, ICMP
      details, OSPF packet types, and oversized IP packet warnings; interface
      statistics showing IP, TCP, UDP, ICMP, non-IP and other IP packet counts,
      IP checksum errors, interface activity and packet size counts; a TCP and
      UDP service monitor showing counts of incoming and outgoing packets for
      common TCP and UDP application ports, a LAN statistics module that
      discovers active hosts and displays statistics about their activity; TCP,
      UDP and other protocol display filters so you can view just the traffic
      you want; logging; support for Ethernet, FDDI, ISDN, SLIP, PPP, and
      loopback interfaces; and utilization of the built-in raw socket interface
      of the Linux kernel, so it can be used on a wide variety of supported
      network cards.
    '';
    homepage = "https://github.com/iptraf-ng/iptraf-ng";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ devhell ];
    mainProgram = "iptraf-ng";
  };
}
