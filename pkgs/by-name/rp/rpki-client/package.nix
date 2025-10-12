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
  version = "9.6";
  openbsd = fetchFromGitHub {
    name = "portable";
    owner = "rpki-client";
    repo = "rpki-client-openbsd";
    tag = "rpki-client-${version}";
    hash = "sha256-Zef7uxD0jh1xdqPh+7R0bMNSPHucfXkDDU0q2JC6kGg=";
  };
in
stdenv.mkDerivation {
  pname = "rpki-client";
  inherit version;

  src = fetchFromGitHub {
    owner = "rpki-client";
    repo = "rpki-client-portable";
    tag = version;
    hash = "sha256-emwYvo4sayLOBMLuqwk+HiJfyZ+UsVh4wZsk6ol0k1M=";
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

  meta = {
    description = "rpki-client is a FREE, easy-to-use implementation of the Resource Public Key Infrastructure (RPKI) for Relying Parties (RP) to facilitate validation of BGP announcements";
    license = lib.licenses.isc;
    homepage = "https://rpki-client.org";
    maintainers = with lib.maintainers; [ seike ];
    platforms = lib.platforms.linux;
  };
}
