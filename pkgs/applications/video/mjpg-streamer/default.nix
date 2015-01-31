{stdenv, fetchsvn, pkgconfig, libjpeg, imagemagick, libv4l}:

stdenv.mkDerivation rec {
  rev = "182";
  name = "mjpg-streamer-${rev}";

  src = fetchsvn {
    url = https://mjpg-streamer.svn.sourceforge.net/svnroot/mjpg-streamer/mjpg-streamer;
    inherit rev;
    sha256 = "008k2wk6xagprbiwk8fvzbz4dd6i8kzrr9n62gj5i1zdv7zcb16q";
  };

  patchPhase = ''
    substituteInPlace Makefile "make -C plugins\/input_gspcav1" "# make -C plugins\/input_gspcav1"
    substituteInPlace Makefile "cp plugins\/input_gspcav1\/input_gspcav1.so" "# cp plugins\/input_gspcav1\/input_gspcav1.so"
  '';

  postFixup = ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/mjpg_streamer):$out/lib:$out/lib/plugins" $out/bin/mjpg_streamer
  '';

  makeFlags = "DESTDIR=$(out)";

  preInstall = ''
    mkdir -p $out/{bin,lib}
  '';

  buildInputs = [ pkgconfig libjpeg imagemagick libv4l ];
  
  meta = {
    homepage = http://sourceforge.net/projects/mjpg-streamer/;
    description = "MJPG-streamer takes JPGs from Linux-UVC compatible webcams, filesystem or other input plugins and streams them as M-JPEG via HTTP to webbrowsers, VLC and other software";
  };
}
