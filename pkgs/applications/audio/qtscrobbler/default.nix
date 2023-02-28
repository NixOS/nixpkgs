{ stdenv, lib, fetchurl, withMtp ? true, libmtp, pkg-config, which, qt4, qmake4Hook }:

stdenv.mkDerivation rec {
  pname = "qtscrobbler";
  version = "0.11";

  src = fetchurl {
    url = "mirror://sourceforge/qtscrob/qtscrob/${version}/qtscrob-${version}.tar.bz2";
    sha256 = "01c8e48f616ed09504833d27d92fd62f455bd645ea2d1cc2a5f4c287d641daba";
  };

  nativeBuildInputs = [ qmake4Hook ] ++ lib.optionals withMtp [ pkg-config which ];
  buildInputs = [ qt4 ] ++ lib.optional withMtp libmtp;

  enableParallelBuilding = true;

  postPatch = ''
    cd src
    sed -i -e "s,/usr/local,$out," -e "s,/usr,," common.pri
  '';

  meta = with lib; {
    description = "Qt based last.fm scrobbler";
    longDescription = ''
      QTScrobbler is a tool to upload information about the tracks you have played from your Digital Audio Player (DAP) to your last.fm account.
      It is able to gather this information from Apple iPods or DAPs running the Rockbox replacement firmware.
    '';

    homepage = "https://qtscrob.sourceforge.net";
    license = licenses.gpl2;
    maintainers = [ maintainers.vanzef ];
    platforms = platforms.linux;
  };
}
