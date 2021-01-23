{ lib, stdenv, fetchFromGitHub, libupnp, gpgme, gnome3, glib, libssh, pkg-config, protobuf, bzip2
, libXScrnSaver, speex, curl, libxml2, libxslt, sqlcipher, libmicrohttpd, opencv, qmake, ffmpeg_3
, qtmultimedia, qtx11extras, qttools }:

stdenv.mkDerivation rec {
  pname = "retroshare";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "RetroShare";
    repo = "RetroShare";
    rev = "v${version}";
    sha256 = "0hly2x87wdvqzzwf3wjzi7092bj8fk4xs6302rkm8gp9bkkmiiw8";
  };

  # NIX_CFLAGS_COMPILE = [ "-I${glib.dev}/include/glib-2.0" "-I${glib.dev}/lib/glib-2.0/include" "-I${libxml2.dev}/include/libxml2" "-I${sqlcipher}/include/sqlcipher" ];

  patchPhase = ''
    # Fix build error
    sed -i 's/UpnpString_get_String(es_event->PublisherUrl)/es_event->PublisherUrl/' \
      libretroshare/src/upnp/UPnPBase.cpp
  '';

  nativeBuildInputs = [ pkg-config qmake ];
  buildInputs = [
    speex libupnp gpgme gnome3.libgnome-keyring glib libssh qtmultimedia qtx11extras qttools
    protobuf bzip2 libXScrnSaver curl libxml2 libxslt sqlcipher libmicrohttpd opencv ffmpeg_3
  ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags DESTDIR=$out"
  '';

  # gui/settings/PluginsPage.h:25:28: fatal error: ui_PluginsPage.h: No such file or directory
  enableParallelBuilding = false;

  postInstall = ''
    mkdir -p $out/bin
    mv $out/RetroShare06-nogui $out/bin/RetroShare-nogui
    mv $out/RetroShare06 $out/bin/Retroshare
    ln -s $out/bin/RetroShare-nogui $out/bin/retroshare-nogui

    # plugins
    mkdir -p $out/share/retroshare
    mv $out/lib* $out/share/retroshare

    # BT DHT bootstrap
    cp libbitdht/src/bitdht/bdboot.txt $out/share/retroshare
  '';

  meta = with lib; {
    description = "";
    homepage = "http://retroshare.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
    broken = true; # broken by libupnp: 1.6.21 -> 1.8.3 (#41684)
  };
}
