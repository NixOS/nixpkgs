{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  readline,
  ncurses,
  zlib,
  bash,
  dataDir ? "/var/lib/softether",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "softether";
  version = "4.44-9807-rtm";

  src = fetchFromGitHub {
    owner = "SoftEtherVPN";
    repo = "SoftEtherVPN_Stable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-roi5M/YmSBH44pRPSVZcADIHDbSpAfASiPbTdijisUM=";
  };

  buildInputs = [
    openssl
    readline
    ncurses
    zlib
    bash
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

  postInstall = ''
    substituteInPlace $out/bin/vpnbridge --replace-fail /var/lib/softether/vpnbridge/vpnbridge $out/var/lib/softether/vpnbridge/vpnbridge
    substituteInPlace $out/bin/vpnclient --replace-fail /var/lib/softether/vpnclient/vpnclient $out/var/lib/softether/vpnclient/vpnclient
    substituteInPlace $out/bin/vpncmd --replace-fail /var/lib/softether/vpncmd/vpncmd $out/var/lib/softether/vpncmd/vpncmd
    substituteInPlace $out/bin/vpnserver --replace-fail /var/lib/softether/vpnserver/vpnserver $out/var/lib/softether/vpnserver/vpnserver
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-incompatible-pointer-types"
    "-Wno-implicit-function-declaration"
  ];

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
