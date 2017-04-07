{ stdenv, fetchFromGitHub, lv2 }:

stdenv.mkDerivation rec {
  name = "mod-distortion-${version}";
  version = "git-2015-05-18";

  src = fetchFromGitHub {
    owner = "portalmod";
    repo = "mod-distortion";
    rev = "0cdf186abc2a9275890b57057faf5c3f6d86d84a";
    sha256 = "1wmxgpcdcy9m7j78yq85824if0wz49wv7mw13bj3sw2s87dcmw19";
  };

  buildInputs = [ lv2 ];

  installFlags = [ "LV2_PATH=$(out)/lib/lv2"  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/portalmod/mod-distortion;
    description = "Analog distortion emulation lv2 plugins";
    license = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
