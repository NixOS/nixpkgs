{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  pkg-config,
  libtool,
}:

stdenv.mkDerivation rec {
  version = "3.2p4";
  pname = "libow";

  src = fetchFromGitHub {
    owner = "owfs";
    repo = "owfs";
    rev = "v${version}";
    sha256 = "0dln1ar7bxwhpi36sccmpwapy7iz4j097rbf02mgn42lw5vrcg3s";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
  ];

  preConfigure = ''
    # Tries to use glibtoolize on Darwin, but it shouldn't for Nix.
    sed -i -e 's/glibtoolize/libtoolize/g' bootstrap
    ./bootstrap
  '';

  configureFlags = [
    "--disable-owtcl"
    "--disable-owphp"
    "--disable-owpython"
    "--disable-zero"
    "--disable-owshell"
    "--disable-owhttpd"
    "--disable-owftpd"
    "--disable-owserver"
    "--disable-owperl"
    "--disable-owtap"
    "--disable-owmon"
    "--disable-owexternal"
  ];

  meta = with lib; {
    description = "1-Wire File System full library";
    homepage = "https://owfs.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ disserman ];
    platforms = platforms.unix;
  };
}
