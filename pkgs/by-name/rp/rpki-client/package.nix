{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  expat,
  zlib,
  libressl,
  openssl,
  rsync,
  m4,
  bison,
}:

let
  openbsd = fetchFromGitHub {
    name = "portable";
    owner = "rpki-client";
    repo = "rpki-client-openbsd";
    rev = "master";
    sha256 = "sha256-mdg2gbwG+sm+a3HtLhzVy1pHtuTf8RmkrQFq5yKfrKA=";
  };
in
stdenv.mkDerivation rec {
  pname = "rpki-client";
  version = "9.6";

  src = fetchFromGitHub {
    owner = "rpki-client";
    repo = "rpki-client-portable";
    rev = version;
    sha256 = "sha256-emwYvo4sayLOBMLuqwk+HiJfyZ+UsVh4wZsk6ol0k1M=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    expat
    zlib
    libressl
    openssl
    rsync
    m4
    bison
  ];

  preConfigure = ''
    mkdir ./openbsd
    cp -r ${openbsd}/* ./openbsd/
    chmod -R +w ./openbsd
    ./autogen.sh
  '';

  meta = with lib; {
    description = "rpki-client is a FREE, easy-to-use implementation of the Resource Public Key Infrastructure (RPKI) for Relying Parties (RP) to facilitate validation of BGP announcements";
    license = licenses.isc;
    homepage = "https://rpki-client.org";
    maintainers = with maintainers; [ seike ];
    platforms = platforms.linux;
  };
}

