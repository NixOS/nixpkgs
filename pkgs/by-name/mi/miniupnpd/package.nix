{
  stdenv,
  lib,
  fetchurl,
  libuuid,
  linuxHeaders,
  openssl,
  pkg-config,
  which,
  coreutils,
  makeWrapper,
  nixosTests,
  nftables,
  libmnl,
  libnftnl,
}:

let
  scriptBinEnv = lib.makeBinPath [
    # needed for dirname in nft_*.sh & cat in nft_init.sh
    coreutils
    # used in miniupnpd_functions.sh:
    which
    nftables
  ];
in
stdenv.mkDerivation rec {
  pname = "miniupnpd";
  version = "2.3.10";

  src = fetchurl {
    url = "https://miniupnp.tuxfamily.org/files/miniupnpd-${version}.tar.gz";
    sha256 = "sha256-+cNO02MvtgzSSN1Yl72YR5oQOnVoiwVsovBp5oqzKYc=";
  };

  buildInputs = [
    libuuid
    openssl
    libmnl
    libnftnl
  ];
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  # ./configure is not a standard configure file, errors with:
  # Option not recognized : --prefix=
  dontAddPrefix = true;
  # Similar for cross flags --host/--build
  configurePlatforms = [ ];
  configureFlags = [
    "--host-os=${stdenv.hostPlatform.uname.system}"
    "--host-os-version=${linuxHeaders.version}"
    "--host-machine=${stdenv.hostPlatform.uname.processor}"
    "--firewall=nftables"
    # allow using various config options
    "--ipv6"
    "--igd2"
    "--leasefile"
    "--regex"
    "--vendorcfg"
    # hardening
    "--portinuse"
  ];

  installFlags = [
    "PREFIX=$(out)"
    "INSTALLPREFIX=$(out)"
  ];

  postFixup = ''
    for script in $out/etc/miniupnpd/nft_{delete_chain,flush,init,removeall}.sh
    do
      wrapProgram "$script" --suffix PATH : '${scriptBinEnv}'
    done
  '';

  passthru.tests = {
    bittorrent-integration = nixosTests.bittorrent;
    inherit (nixosTests) upnp;
  };

  meta = {
    homepage = "https://miniupnp.tuxfamily.org/";
    description = "Daemon that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.booxter ];
    mainProgram = "miniupnpd";
  };
}
