{ fetchFromGitHub, stdenv, pkgconfig, autoreconfHook
, openssl, db48, boost, zlib, miniupnpc, gmp
, qrencode, glib, protobuf, yasm, libevent
, utillinux, qtbase ? null, qttools ? null
, enableUpnp ? false
, disableWallet ? false
, disableDaemon ? false 
, withGui ? false }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "pivx-${version}";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "PIVX-Project";
    repo= "PIVX";
    rev = "v${version}";
    sha256 = "1sym6254vhq8qqpxq9qhy10m5167v7x93kqaj1gixc1vwwbxyazy";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ glib gmp openssl db48 yasm boost zlib libevent miniupnpc protobuf utillinux ]
                  ++ optionals withGui [ qtbase qttools qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                    ++ optional enableUpnp "--enable-upnp-default"
                    ++ optional disableWallet "--disable-wallet"
                    ++ optional disableDaemon "--disable-daemon"
                    ++ optionals withGui [ "--with-gui=yes"
                                           "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
                                         ];
  
  enableParallelBuilding = true;
  doChecks = true;
  postBuild = ''
    mkdir -p $out/share/applications $out/share/icons
    cp contrib/debian/pivx-qt.desktop $out/share/applications/
    cp share/pixmaps/*128.png $out/share/icons/
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
  };
}
