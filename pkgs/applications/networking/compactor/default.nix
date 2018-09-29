{ autoconf, automake, boost, cbor-diag, cddl, fetchFromGitHub, file, libpcap, libtins, libtool, lzma, openssl, pkgconfig, stdenv, tcpdump, wireshark-cli }:

stdenv.mkDerivation rec {
  name = "compactor-${version}";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "dns-stats";
    repo = "compactor";
    rev = "${version}";
    sha256 = "0bd82956nkpdmfj8f05z37hy7f33cd2nfdxr7s9fgz1xi5flnzjc";
  };

  # cbor-diag, cddl and wireshark-cli are only used for tests.
  nativeBuildInputs = [ autoconf automake libtool pkgconfig cbor-diag cddl wireshark-cli ];
  buildInputs = [
    boost
    libpcap
    openssl
    libtins
    lzma
  ];

  patchPhase = ''
    patchShebangs test-scripts/
  '';

  preConfigure = ''
    sh autogen.sh
    substituteInPlace configure \
      --replace "/usr/bin/file" "${file}/bin/file"
  '';
  CXXFLAGS = "-std=c++11";
  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--with-boost=${boost.dev}"
  ];

  doCheck = true;
  preCheck = ''
    substituteInPlace test-scripts/check-live-pcap.sh \
      --replace "/usr/sbin/tcpdump" "${tcpdump}/bin/tcpdump"
  '';

  meta = with stdenv.lib; {
    description = "Tools to capture DNS traffic and record it in C-DNS files";
    homepage    = http://dns-stats.org/;
    license     = [ licenses.boost licenses.mpl20 licenses.openssl ];
    maintainers = with maintainers; [ fdns ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
