{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libpcap,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ngrep";
  version = "1.49.0";

  src = fetchFromGitHub {
    owner = "jpr5";
    repo = "ngrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qlzxtIsim7ABRwZ4lVQosH+EXkiIK3pb2Ug0OdMZrHs=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    libpcap
    pcre2
  ];

  configureFlags = [
    "--enable-ipv6"
    "--enable-pcre2"
    "--disable-pcap-restart"
    "--with-pcap-includes=${libpcap}/include"
  ];

  preConfigure = ''
    sed -i "s|BPF=.*|BPF=${libpcap}/include/pcap/bpf.h|" configure
  '';

  meta = {
    description = "Network packet analyzer";
    longDescription = ''
      ngrep strives to provide most of GNU grep's common features, applying
      them to the network layer. ngrep is a pcap-aware tool that will allow you
      to specify extended regular or hexadecimal expressions to match against
      data payloads of packets. It currently recognizes IPv4/6, TCP, UDP,
      ICMPv4/6, IGMP and Raw across Ethernet, PPP, SLIP, FDDI, Token Ring and
      null interfaces, and understands BPF filter logic in the same fashion as
      more common packet sniffing tools, such as tcpdump and snoop.
    '';
    homepage = "https://github.com/jpr5/ngrep/";
    license = {
      shortName = "ngrep"; # BSD-style, see README.md and LICENSE
      url = "https://github.com/jpr5/ngrep/blob/master/LICENSE";
      free = true;
      redistributable = true;
    };
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = [ lib.maintainers.bjornfor ];
    mainProgram = "ngrep";
  };
})
