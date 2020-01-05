{ fetchFromGitHub, stdenv, pkgconfig, autoreconfHook, wrapQtAppsHook ? null
, openssl_1_0_2, db48, boost, zlib, miniupnpc, gmp
, qrencode, glib, protobuf, yasm, libevent
, utillinux, qtbase ? null, qttools ? null
, enableUpnp ? false
, disableWallet ? false
, disableDaemon ? false 
, withGui ? false }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "pivx-${version}";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "PIVX-Project";
    repo= "PIVX";
    rev = "v${version}";
    sha256 = "0m85nc7c8cppdysqz4m12rgmzacrcbwnvf7wy90wzfvfr3xkbapd";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ] ++ optionals withGui [ wrapQtAppsHook ];
  buildInputs = [ glib gmp openssl_1_0_2 db48 yasm boost zlib libevent miniupnpc protobuf utillinux ]
                  ++ optionals withGui [ qtbase qttools qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                    ++ optional enableUpnp "--enable-upnp-default"
                    ++ optional disableWallet "--disable-wallet"
                    ++ optional disableDaemon "--disable-daemon"
                    ++ optionals withGui [ "--with-gui=yes"
                                           "--with-unsupported-ssl" # TODO remove this ASAP
                                           "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
                                         ];
  
  enableParallelBuilding = true;
  doChecks = true;
  postBuild = ''
    mkdir -p $out/share/applications $out/share/icons
    cp contrib/debian/pivx-qt.desktop $out/share/applications/
    cp share/pixmaps/*128.png $out/share/icons/
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/test_pivx
  '';

  meta = with stdenv.lib; {
    description = "An open source crypto-currency focused on fast private transactions";
    longDescription = ''
      PIVX is an MIT licensed, open source, blockchain-based cryptocurrency with
      ultra fast transactions, low fees, high network decentralization, and
      Zero Knowledge cryptography proofs for industry-leading transaction anonymity.
    '';
    license = licenses.mit;
    homepage = https://www.dash.org;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.unix;
    # TODO
    # upstream doesn't support newer openssl versions
    # https://github.com/PIVX-Project/PIVX/issues/748
    # openssl_1_0_2 should be replaced with openssl ASAP
  };
}
