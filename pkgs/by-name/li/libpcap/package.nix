{
  lib,
  stdenv,
  bison,
  bluez,
  fetchurl,
  flex,
  libnl,
  libxcrypt,
  pkg-config,
  withBluez ? lib.meta.availableOn stdenv.hostPlatform bluez,
  # `withRemote` disabled by default because:
  # > configure: WARNING: Remote packet capture may expose libpcap-based
  # > applications to attacks by malicious remote capture servers!
  withRemote ? false,

  # for passthru.tests
  ettercap,
  haskellPackages,
  nmap,
  ostinato,
  python3,
  tcpreplay,
  vde2,
  wireshark,
}:

stdenv.mkDerivation rec {
  pname = "libpcap";
  version = "1.10.5";

  src = fetchurl {
    url = "https://www.tcpdump.org/release/${pname}-${version}.tar.gz";
    hash = "sha256-N87ZChmjAqfzLkWCJKAMNlwReQXCzTWsVEtogKgUiPA=";
  };

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ libnl ]
    ++ lib.optionals withBluez [ bluez.dev ]
    ++ lib.optionals withRemote [ libxcrypt ];

  nativeBuildInputs = [
    bison
    flex
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  # We need to force the autodetection because detection doesn't
  # work in pure build environments.
  configureFlags = [
    "--with-pcap=${if stdenv.hostPlatform.isLinux then "linux" else "bpf"}"
    (lib.enableFeature withBluez "bluetooth")
    (lib.enableFeature withRemote "remote")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--disable-universal"
  ]
  ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [ "ac_cv_linux_vers=2" ];

  postInstall = ''
    if [ "$dontDisableStatic" -ne "1" ]; then
      rm -f $out/lib/libpcap.a
    fi
  '';

  enableParallelBuilding = true;
  strictDeps = true;

  passthru.tests = {
    inherit
      ettercap
      nmap
      ostinato
      tcpreplay
      vde2
      wireshark
      ;
    inherit (python3.pkgs) pcapy-ng scapy;
    haskell-pcap = haskellPackages.pcap;
  };

  meta = with lib; {
    homepage = "https://www.tcpdump.org";
    description = "Packet Capture Library";
    mainProgram = "pcap-config";
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.bsd3;
  };
}
