{ stdenv, fetchFromGitHub, libX11 }:

stdenv.mkDerivation rec {
  name = "xkbmon-${version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "xkbmon";
    repo = "xkbmon";
    rev = version;
    sha256 = "1smyqsd9cpbzqaplm221a8mq0nham6rg6hjsm9g5gph94xmk6d67";
  };

  buildInputs = [ libX11 ];

  installPhase = "install -D -t $out/bin xkbmon";

  meta = with stdenv.lib; {
    homepage = https://github.com/xkbmon/xkbmon;
    description = "Command-line keyboard layout monitor for X11";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
