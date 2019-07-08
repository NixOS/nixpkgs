{ autoconf, automake, boost, cbor-diag, cddl, fetchFromGitHub, file, libctemplate, libmaxminddb
, libpcap, libtins, libtool, lzma, openssl, pkgconfig, stdenv, tcpdump, wireshark-cli
}:

stdenv.mkDerivation rec {
  pname = "compactor";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "dns-stats";
    repo = pname;
    rev = version;
    sha256 = "17p9wsslsh6ifnadvyygr0cgir4q4iirxfz9zpkpbhh76cx2qnay";
  };

  # cbor-diag, cddl and wireshark-cli are only used for tests.
  nativeBuildInputs = [ autoconf automake libtool pkgconfig cbor-diag cddl wireshark-cli ];
  buildInputs = [
    boost
    libpcap
    openssl
    libtins
    lzma
    libctemplate
    libmaxminddb
  ];

  prePatch = ''
    patchShebangs test-scripts/
  '';

  preConfigure = ''
    ${stdenv.shell} autogen.sh
    substituteInPlace configure \
      --replace "/usr/bin/file" "${file}/bin/file"
  '';
  CXXFLAGS = "-std=c++11";
  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--with-boost=${boost.dev}"
  ];
  enableParallelBuilding = true;

  doCheck = true;
  preCheck = ''
    substituteInPlace test-scripts/check-live-pcap.sh \
      --replace "/usr/sbin/tcpdump" "${tcpdump}/bin/tcpdump"
    rm test-scripts/same-tshark-output.sh
  ''; # TODO: https://github.com/dns-stats/compactor/issues/49  (failing test)

  meta = with stdenv.lib; {
    description = "Tools to capture DNS traffic and record it in C-DNS files";
    homepage    = "http://dns-stats.org/";
    changelog   = "https://github.com/dns-stats/${pname}/raw/${version}/ChangeLog.txt";
    license     = [ licenses.boost licenses.mpl20 licenses.openssl ];
    maintainers = with maintainers; [ fdns ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
