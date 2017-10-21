{ stdenv, lib, fetchFromGitHub, autoconf, automake, which, libtool, pkgconfig
, ronn
, pcaudiolibSupport ? true, pcaudiolib
, sonicSupport ? true, sonic }:

stdenv.mkDerivation rec {
  name = "espeak-ng-${version}";
  version = "2016-08-28";

  src = fetchFromGitHub {
    owner = "espeak-ng";
    repo = "espeak-ng";
    rev = "b784e77c5708b61feed780d8f1113c4c8eb92200";
    sha256 = "1whix4mv0qvsvifgpwwbdzhv621as3rxpn9ijqc2683h6k8pvcfk";
  };

  nativeBuildInputs = [ autoconf automake which libtool pkgconfig ronn ];

  buildInputs = lib.optional pcaudiolibSupport pcaudiolib
             ++ lib.optional sonicSupport sonic;

  preConfigure = "./autogen.sh";

  postInstall = ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/espeak-ng)" $out/bin/speak-ng
  '';

  meta = with stdenv.lib; {
    description = "Open source speech synthesizer that supports over 70 languages, based on eSpeak";
    homepage = https://github.com/espeak-ng/espeak-ng;
    license = licenses.gpl3;
    maintainers = with maintainers; [ aske ];
    platforms = platforms.linux;
  };
}
