{ stdenv, lib, fetchurl, withMtp ? true, libmtp, pkgconfig, which, qt4 }:

stdenv.mkDerivation rec {
  name = "qtscrobbler-${version}";
  version = "0.11";

  src = fetchurl {
    url = "mirror://sourceforge/qtscrob/qtscrob/${version}/qtscrob-${version}.tar.bz2";
    sha256 = "01c8e48f616ed09504833d27d92fd62f455bd645ea2d1cc2a5f4c287d641daba";
  };

  nativeBuildInputs = lib.optionals withMtp [ pkgconfig which ];
  buildInputs = [ qt4 ] ++ lib.optional withMtp libmtp;

  enableParallelBuilding = true;

  postPatch = ''
    cd src
    sed -i "s,/usr/local,$out," common.pri
  '';

  configurePhase = "qmake";

  meta = with lib; {
    description = "Qt based last.fm scrobbler";
    longDescription = ''
      QTScrobbler is a tool to upload information about the tracks you have played from your Digital Audio Player (DAP) to your last.fm account.
      It is able to gather this information from Apple iPods or DAPs running the Rockbox replacement firmware.
    '';

    homepage = http://qtscrob.sourceforge.net;
    license = licenses.gpl2;
    maintainers = [ maintainers.vanzef ];
    platforms = platforms.linux;
  };
}
