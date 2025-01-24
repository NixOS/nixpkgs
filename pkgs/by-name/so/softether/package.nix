{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  readline,
  ncurses,
  zlib,
  dataDir ? "/var/lib/softether",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "softether";
  version = "4.41-9782-beta";

  src = fetchFromGitHub {
    owner = "SoftEtherVPN";
    repo = "SoftEtherVPN_Stable";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-yvN5hlfAtE+gWm0s/TY/Lp53By5SDHyQIvvDutRnDNQ=";
  };

  buildInputs = [
    openssl
    readline
    ncurses
    zlib
  ];

  preConfigure = ''
    ./configure
  '';

  buildPhase = ''
    mkdir -p $out/bin
    sed -i \
      -e "/INSTALL_BINDIR=/s|/usr/bin|/bin|g" \
      -e "/_DIR=/s|/usr|${dataDir}|g" \
      -e "s|\$(INSTALL|$out/\$(INSTALL|g" \
      -e "/echo/s|echo $out/|echo |g" \
      Makefile
  '';

  meta = {
    description = "Open-Source Free Cross-platform Multi-protocol VPN Program";
    homepage = "https://www.softether.org/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.rick68 ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
