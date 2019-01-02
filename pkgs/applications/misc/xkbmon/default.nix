{ stdenv, fetchFromGitHub, libX11 }:

stdenv.mkDerivation rec {
  name = "xkbmon-${version}";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "xkbmon";
    repo = "xkbmon";
    rev = version;
    sha256 = "1x2xwak0yp0xkl63jzz3k1pf074mh9yxgppwwm96ms3zaslq44yp";
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
