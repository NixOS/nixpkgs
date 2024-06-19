{ mkDerivation, lib, fetchgit, pkg-config, qmake, qtbase, qttools, qtmultimedia, libvorbis, libtar, libxml2 }:

mkDerivation rec {
  version = "0.8.5";
  pname = "linuxstopmotion";

  src = fetchgit {
    url = "https://git.code.sf.net/p/linuxstopmotion/code";
    rev = version;
    sha256 = "1612lkwsfzc59wvdj2zbj5cwsyw66bwn31jrzjrxvygxdh4ab069";
  };

  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [ qtbase qttools qtmultimedia libvorbis libtar libxml2 ];

  postPatch = ''
    substituteInPlace stopmotion.pro --replace '$$[QT_INSTALL_BINS]' '${lib.getDev qttools}/bin'
  '';

  meta = with lib; {
    description = "Create stop-motion animation movies";
    homepage = "http://linuxstopmotion.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "stopmotion";
  };
}
