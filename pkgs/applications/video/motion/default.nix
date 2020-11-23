{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkgconfig
, ffmpeg, libjpeg, libmicrohttpd }:

stdenv.mkDerivation rec {
  pname = "motion";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner  = "Motion-Project";
    repo   = "motion";
    rev    = "Release-${version}";
    sha256 = "08mm7ajgs0qnrydywxxyzcll09z80crjnjkjnckdi6ljsj6s96j8";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2020-26566.patch";
      url = "https://github.com/Motion-Project/motion/commit/5c9b907ddd4d096f0485831869a29dc0fbfbb800.diff";
      sha256 = "0q4yl5k5w37kgxsipxaw20mx238s50lmvhlqrsyh8w31qr3dwgx4";
      excludes = [ ".travis.yml" ];
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ ffmpeg libjpeg libmicrohttpd ];

  meta = with stdenv.lib; {
    description = "Monitors the video signal from cameras";
    homepage = https://motion-project.github.io/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ puffnfresh veprbl ];
  };
}
