{ stdenv, fetchFromGitHub, libX11 }:

stdenv.mkDerivation rec {
  name = "xkbmon-${version}";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "xkbmon";
    repo = "xkbmon";
    rev = version;
    sha256 = "03v8f6fijgwagjphyj8w7lgh5hlc8jk0j2n45n7fm0xwy82cxxx9";
  };

  buildInputs = [ libX11 ];

  installPhase = "install -D -t $out/bin xkbmon";

  meta = with stdenv.lib; {
    homepage = https://github.com/xkbmon/xkbmon;
    description = "Command-line keyboard layout monitor for X11";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
