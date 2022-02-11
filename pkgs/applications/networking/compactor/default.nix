{ lib, stdenv, fetchFromGitHub
, asciidoctor, autoreconfHook, pkg-config
, boost, libctemplate, libmaxminddb, libpcap, libtins, openssl, protobuf, xz, zlib
, cbor-diag, cddl, diffutils, file, mktemp, netcat, tcpdump, wireshark-cli
}:

stdenv.mkDerivation rec {
  pname = "compactor";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "dns-stats";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-AUNPUk70VwJ0nZgMPLMU258nqkL4QP6km0USrZi2ea0=";
  };

  nativeBuildInputs = [
    asciidoctor
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    boost
    libctemplate
    libmaxminddb
    libpcap
    libtins
    openssl
    protobuf
    xz
    zlib
  ];

  postPatch = ''
    patchShebangs test-scripts/
  '';

  preConfigure = ''
    substituteInPlace configure \
      --replace "/usr/bin/file" "${file}/bin/file"
  '';

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--with-boost=${boost.dev}"
  ];
  enableParallelBuilding = true;

  doCheck = !stdenv.isDarwin; # check-dnstap.sh failing on Darwin
  checkInputs = [
    cbor-diag
    cddl
    diffutils
    file
    mktemp
    netcat
    tcpdump
    wireshark-cli
  ];

  meta = with lib; {
    description = "Tools to capture DNS traffic and record it in C-DNS files";
    homepage    = "https://dns-stats.org/";
    changelog   = "https://github.com/dns-stats/${pname}/raw/${version}/ChangeLog.txt";
    license     = licenses.mpl20;
    maintainers = with maintainers; [ fdns ];
    platforms   = platforms.unix;
  };
}
