{ fetchurl, stdenv, openssl, db4, boost, zlib, glib, libSM, gtk, wxGTK }:

stdenv.mkDerivation rec {
  version = "0.3.20.2";
  name = "bitcoin-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/bitcoin/Bitcoin/bitcoin-0.3.20/bitcoin-0.3.20.2-linux.tar.gz";
    sha256 = "1maq75myqkyngfi9ngaw6kv6nfia5wsjj2zjhns75k3wxhmvgpw5";
  };

  buildInputs = [ openssl db4 boost zlib glib libSM gtk wxGTK ];

  preConfigure = ''
    cd src
    mkdir obj
    mkdir obj/nogui
    substituteInPlace makefile.unix \
      --replace "-Wl,-Bstatic" "" \
      --replace "-Wl,-Bdynamic" "" \
      --replace "-mt \\" " \\" \
      --replace "-l wx_gtk2ud-2.9" "-l wx_gtk2u_core-2.9 -l wx_gtk2u_html-2.9 -l wx_gtk2u_adv-2.9" \
      --replace "DEBUGFLAGS=-g -D__WXDEBUG__" "DEBUGFLAGS=" \
      --replace "/usr/local/include/wx-2.9" "${wxGTK}/include/wx-2.9" \
      --replace "/usr/local/lib/wx/include/gtk2-unicode-debug-static-2.9" "${wxGTK}/lib/wx/include/gtk2-unicode-release-2.9"
  '';

  makefile = "makefile.unix";

  preBuild = "make -f ${makefile} clean";

  buildFlags = "bitcoin bitcoind";

  installPhase = ''
    ensureDir $out/bin
    cp bitcoin $out/bin
    cp bitcoind $out/bin
  '';

  meta = { 
      description = "Bitcoin is a peer-to-peer currency";
      longDescription=''
Bitcoin is a free open source peer-to-peer electronic cash system that is
completely decentralized, without the need for a central server or trusted
parties.  Users hold the crypto keys to their own money and transact directly
with each other, with the help of a P2P network to check for double-spending.
      '';
      homepage = "http://www.bitcoin.org/";
      maintainers = [ stdenv.lib.maintainers.roconnor ];
      license = "MIT";
  };
}
