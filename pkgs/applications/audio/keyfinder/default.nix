{ lib, mkDerivation, fetchFromGitHub, libav_0_8, libkeyfinder, qtbase, qtxmlpatterns, qmake, taglib }:

mkDerivation rec {
  pname = "keyfinder";
  version = "2.4";

  src = fetchFromGitHub {
    sha256 = "11yhdwan7bz8nn8vxr54drckyrnlxynhx5s981i475bbccg8g7ls";
    rev = "530034d6fe86d185f6a68b817f8db5f552f065d7"; # tag is missing
    repo = "is_KeyFinder";
    owner = "ibsh";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ libav_0_8 libkeyfinder qtbase qtxmlpatterns taglib ];

  postPatch = ''
    substituteInPlace is_KeyFinder.pro \
       --replace "-stdlib=libc++" "" \
       --replace "\$\$[QT_INSTALL_PREFIX]" "$out"
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Musical key detection for digital audio (graphical UI)";
    longDescription = ''
      KeyFinder is an open source key detection tool, for DJs interested in
      harmonic and tonal mixing. Designed primarily for electronic and dance
      music, it is highly configurable and can be applied to many genres. It
      supports a huge range of codecs thanks to LibAV, and writes to metadata
      tags using TagLib. It's intended to be very focused: no library
      management, no track suggestions, no media player. Just a fast,
      efficient workflow tool.
    '';
    homepage = "https://www.ibrahimshaath.co.uk/keyfinder/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
