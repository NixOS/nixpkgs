{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
  bison,
  flex,
  geoip,
  geolite-legacy,
  libcli,
  libnet,
  libnetfilter_conntrack,
  libnl,
  libpcap,
  libsodium,
  liburcu,
  ncurses,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsniff-ng";
  version = "0.6.9";

  src = fetchFromGitHub {
    repo = "netsniff-ng";
    owner = "netsniff-ng";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P1xZqhZ/HJV3fAvh4xhhApZ0+FLDFqvYrZlbvb+FV7I=";
  };

  patches = [
    # GCC 15 compatibility
    (fetchpatch {
      url = "https://github.com/netsniff-ng/netsniff-ng/commit/1af7ae33e3e8178ab5c649c3a52838d4375c4228.patch";
      sha256 = "sha256-aNV1Srnr396HsyAKVQoCeGBo/oduxLrUidlZLuI5Rlk=";
    })
  ];

  nativeBuildInputs = [
    bison
    flex
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    geoip
    geolite-legacy
    libcli
    libnet
    libnl
    libnetfilter_conntrack
    libpcap
    libsodium
    liburcu
    ncurses
    zlib
  ];

  # ./configure is not autoGNU but some home-brewn magic
  configurePhase = ''
    runHook preConfigure

    patchShebangs configure
    substituteInPlace configure --replace "which" "command -v"
    NACL_INC_DIR=${libsodium.dev}/include/sodium NACL_LIB=sodium ./configure

    runHook postConfigure
  '';

  enableParallelBuilding = true;

  # All files installed to /etc are just static data that can go in the store
  makeFlags = [
    "PREFIX=$(out)"
    "ETCDIR=$(out)/etc"
  ];

  postInstall = ''
    # trafgen and bpfc can call out to cpp to process config files.
    wrapProgram "$out/sbin/trafgen" --prefix PATH ":" "${stdenv.cc}/bin"
    wrapProgram "$out/sbin/bpfc" --prefix PATH ":" "${stdenv.cc}/bin"

    ln -sv ${geolite-legacy}/share/GeoIP/GeoIP.dat $out/etc/netsniff-ng/country4.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPv6.dat $out/etc/netsniff-ng/country6.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPCity.dat $out/etc/netsniff-ng/city4.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPCityv6.dat $out/etc/netsniff-ng/city6.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPASNum.dat $out/etc/netsniff-ng/asname4.dat
    ln -sv ${geolite-legacy}/share/GeoIP/GeoIPASNumv6.dat $out/etc/netsniff-ng/asname6.dat
    rm -v $out/etc/netsniff-ng/geoip.conf # updating databases after installation is impossible
  '';

  meta = {
    description = "Swiss army knife for daily Linux network plumbing";
    longDescription = ''
      netsniff-ng is a free Linux networking toolkit. Its gain of performance
      is reached by zero-copy mechanisms, so that on packet reception and
      transmission the kernel does not need to copy packets from kernel space
      to user space and vice versa. The toolkit can be used for network
      development and analysis, debugging, auditing or network reconnaissance.
    '';
    homepage = "http://netsniff-ng.org/";
    license = with lib.licenses; [ gpl2Only ];
    platforms = lib.platforms.linux;
  };
})
