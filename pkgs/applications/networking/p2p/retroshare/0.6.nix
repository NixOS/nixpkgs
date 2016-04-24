{ stdenv, fetchFromGitHub, cmake, qt4, qmake4Hook, libupnp, gpgme, gnome3, glib, libssh, pkgconfig, protobuf, bzip2
, libXScrnSaver, speex, curl, libxml2, libxslt, sqlcipher, libmicrohttpd, opencv }:

stdenv.mkDerivation {
  name = "retroshare-0.6-git-fabc3a3";

  src = fetchFromGitHub {
    owner = "RetroShare";
    repo = "RetroShare";
    rev = "fabc3a398536565efe77fb1b1ef37bd484dc7d4a";
    sha256 = "189qndkfq9kgv3qi3wx8ivla4j8fxr4iv7c8y9rjrjaz8jwdkn5x";
  };

  NIX_CFLAGS_COMPILE = [ "-I${glib.dev}/include/glib-2.0" "-I${glib.dev}/lib/glib-2.0/include" "-I${libxml2.dev}/include/libxml2" "-I${sqlcipher}/include/sqlcipher" ];

  patchPhase = ''
    # Fix build error
    sed -i 's/UpnpString_get_String(es_event->PublisherUrl)/es_event->PublisherUrl/' \
      libretroshare/src/upnp/UPnPBase.cpp
    # Extensions get installed 
    sed -i "s,/usr/lib/retroshare/extensions6/,$out/share/retroshare," \
      libretroshare/src/rsserver/rsinit.cc
    # Where to find the bootstrap DHT bdboot.txt
    sed -i "s,/usr/share/RetroShare,$out/share/retroshare," \
      libretroshare/src/rsserver/rsaccounts.cc
  '';

  #  sed -i "s,LIBS +=.*sqlcipher.*,LIBS += -lsqlcipher," \
  #    retroshare-gui/src/retroshare-gui.pro \
  #    retroshare-nogui/src/retroshare-nogui.pro

  buildInputs = [ speex qt4 libupnp gpgme gnome3.libgnome_keyring glib libssh pkgconfig qmake4Hook
                  protobuf bzip2 libXScrnSaver curl libxml2 libxslt sqlcipher libmicrohttpd opencv ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags DESTDIR=$out"
  '';

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/bin
    mv $out/retroshare-nogui $out/bin
    mv $out/RetroShare $out/bin

    # plugins
    mkdir -p $out/share/retroshare
    mv $out/lib* $out/share/retroshare

    # BT DHT bootstrap
    cp libbitdht/src/bitdht/bdboot.txt $out/share/retroshare
  '';

  meta = with stdenv.lib; {
    description = "";
    homepage = http://retroshare.sourceforge.net/;
    #license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.iElectric ];
  };
}
