{ stdenv, lib, fetchurl, mkDerivation
, cryptopp
, qmake
, libusb
, qttools
, pkg-config
, wrapQtAppsHook }:

mkDerivation rec {
  pname = "RockboxUtility";
  version = "1.4.1";

  src = fetchurl {
    url = "http://download.rockbox.org/rbutil/source/RockboxUtility-v${version}-src.tar.bz2";
    sha256 = "0zm9f01a810y7aq0nravbsl0vs9vargwvxnfl4iz9qsqygwlj69y";
  };

  sourceRoot = "${pname}-v${version}/rbutil/rbutilqt";

  buildInputs = [ wrapQtAppsHook qmake cryptopp libusb qttools pkg-config ];

  preConfigure = ''
    lrelease rbutilqt.pro
  '';

  installPhase = ''
    install -dm 755 "$out"/{bin,share/{applications,pixmaps}}
    install -m 755 {,"$out"/bin/}RockboxUtility
    install -m 644 icons/rockbox-256.png "$out"/share/pixmaps/rbutil.png
  '';

  meta = with stdenv.lib; {
    homepage = https://www.rockbox.org/twiki/bin/view/Main/RockboxUtility;
    description = "QT GUI for Rockbox Utility";
    maintainers = with maintainers; [ makefu ];
    license = licenses.gpl2Plus;
  };
}
