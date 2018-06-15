{ stdenv, fetchurl
, pkgconfig
, intltool
, libX11, libXv, libSM
, gtk, libglade
, wxGTK
, perlXMLParser
, xvidcore
, mjpegtools
, alsaLib
, libv4l
, cimg }:

stdenv.mkDerivation rec {

  name = "wxcam-${version}";
  version = "1.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/wxcam/wxcam/${version}/${name}.tar.gz";
    sha256 = "1765bvc65fpzn9ycnnj5hais9xkx9v0sm6a878d35x54bpanr859";
  };

  buildInputs = with stdenv.lib;
  [ pkgconfig intltool libX11 libXv libSM gtk libglade wxGTK perlXMLParser xvidcore mjpegtools alsaLib libv4l cimg ];

  NIX_CFLAGS_COMPILE="-I ${cimg}/include/cimg";

  postUnpack = ''
    sed -ie 's|/usr/share/|'"$out/share/"'|g' $sourceRoot/Makefile.in
  '';

  installPhase = ''
    make install prefix="$out" wxcamdocdir="$out/share/doc/wxcam"
  '';    
  
  meta = with stdenv.lib; {
    description = "An open-source, wxGTK-based webcam app for Linux"; 
    longDescription = ''
    wxCam is a webcam application for linux. It supports video recording
    (avi uncompressed and Xvid formats), snapshot taking, and some special
    commands for philips webcams, so you can also use it for astronomy purposes.
    It supports both video4linux 1 and 2 drivers,
    so it should work on a very large number of devices.
    '';
    homepage = http://wxcam.sourceforge.net/;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
