{ stdenv, lib, fetchFromGitHub, autoconf, automake, which, libtool, pkgconfig
, ronn
, pcaudiolibSupport ? true, pcaudiolib
, sonicSupport ? true, sonic }:

stdenv.mkDerivation rec {
  pname = "espeak-ng";
  version = "1.49.2";

  src = fetchFromGitHub {
    owner = "espeak-ng";
    repo = "espeak-ng";
    rev = version;
    sha256 = "17bbl3zi8214iaaj8kjnancjvmvizwybg3sg17qjq4mf5c6xfg2c";
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
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    maintainers = with maintainers; [ aske ];
    platforms = platforms.linux;
  };
}
