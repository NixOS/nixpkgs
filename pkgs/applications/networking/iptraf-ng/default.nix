{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  version = "1.1.4";
  name = "iptraf-ng-${version}";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/i/p/iptraf-ng/${name}.tar.gz";
    sha256 = "02gb8z9h2s6s1ybyikywz7jgb1mafdx88hijfasv3khcgkq0q53r";
  };

  buildInputs = [ ncurses ];

  configurePhase = ''
    ./configure --prefix=$out/usr --sysconfdir=$out/etc \
                --localstatedir=$out/var --sbindir=$out/bin
  '';

  hardeningDisable = [ "format" ];

  meta = {
    description = "A console-based network monitoring utility (fork of iptraf)";
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
    homepage = https://fedorahosted.org/iptraf-ng/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
