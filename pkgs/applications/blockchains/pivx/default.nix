{ fetchFromGitHub
, lib
, stdenv
, pkg-config
, autoreconfHook
, wrapQtAppsHook
, openssl
, db48
, boost
, zlib
, miniupnpc
, gmp
, qrencode
, glib
, protobuf
, yasm
, libevent
, util-linux
, qtbase
, qttools
, enableUpnp ? false
, disableWallet ? false
, disableDaemon ? false
, withGui ? false
}:

stdenv.mkDerivation rec {
  pname = "pivx";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "PIVX-Project";
    repo = "PIVX";
    rev = "v${version}";
    sha256 = "03ndk46h6093v8s18d5iffz48zhlshq7jrk6vgpjfs6z2iqgd2sy";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ]
    ++ lib.optionals withGui [ wrapQtAppsHook ];

  buildInputs = [ glib gmp openssl db48 yasm boost zlib libevent miniupnpc protobuf util-linux ]
    ++ lib.optionals withGui [ qtbase qttools qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
    ++ lib.optional enableUpnp "--enable-upnp-default"
    ++ lib.optional disableWallet "--disable-wallet"
    ++ lib.optional disableDaemon "--disable-daemon"
    ++ lib.optionals withGui [
    "--with-gui=yes"
    "--with-qt-bindir=${lib.getDev qtbase}/bin:${lib.getDev qttools}/bin"
  ];

  enableParallelBuilding = true;
  doCheck = true;
  postBuild = ''
    mkdir -p $out/share/applications $out/share/icons
    cp contrib/debian/pivx-qt.desktop $out/share/applications/
    cp share/pixmaps/*128.png $out/share/icons/
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/test_pivx
  '';

  meta = with lib; {
    broken = true;
    description = "Open source crypto-currency focused on fast private transactions";
    longDescription = ''
      PIVX is an MIT licensed, open source, blockchain-based cryptocurrency with
      ultra fast transactions, low fees, high network decentralization, and
      Zero Knowledge cryptography proofs for industry-leading transaction anonymity.
    '';
    license = licenses.mit;
    homepage = "https://pivx.org";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
