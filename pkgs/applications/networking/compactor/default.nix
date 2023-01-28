{ lib, stdenv, fetchFromGitHub
, asciidoctor, autoreconfHook, pkg-config
, boost, libctemplate, libmaxminddb, libpcap, libtins, openssl, protobuf, xz, zlib, catch2
, cbor-diag, cddl, diffutils, file, mktemp, netcat, tcpdump, wireshark-cli
}:

stdenv.mkDerivation rec {
  pname = "compactor";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "dns-stats";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-SgmtlbYOrSMzVfzsrbg4qs+yGkXQialiJTI99EBsUjQ=";
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
    cp ${catch2}/include/catch2/catch.hpp tests/catch.hpp
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
  nativeCheckInputs = [
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
