{ stdenv, fetchFromGitHub, cmake, libjpeg }:

stdenv.mkDerivation rec {
  name = "mjpg-streamer-${version}";
  version = "2016-03-08";

  src = fetchFromGitHub {
    owner = "jacksonliam";
    repo = "mjpg-streamer";
    rev = "4060cb64e3557037fd404d10e1c1d076b672e9e8";
    sha256 = "0g7y832jsz4ylmq9qp2l4fq6bm8l6dhsbi60fr5jfqpx4l0pia8m";
  };

  prePatch = ''
    cd mjpg-streamer-experimental
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libjpeg ];

  postFixup = ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/mjpg_streamer):$out/lib/mjpg-streamer" $out/bin/mjpg_streamer
  '';

  meta = with stdenv.lib; {
    homepage = http://sourceforge.net/projects/mjpg-streamer/;
    description = "MJPG-streamer takes JPGs from Linux-UVC compatible webcams, filesystem or other input plugins and streams them as M-JPEG via HTTP to webbrowsers, VLC and other software";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
