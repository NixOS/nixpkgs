{ stdenv, fetchFromGitHub, xorg, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "BSEQuencer";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = "${version}";
    sha256 = "08xwz5v8wrar0rx7qdr9pkpjz2k9sw6bn5glhpn6sp6453fabf8q";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    xorg.libX11 cairo lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/sjaehn/BSEQuencer;
    description = "Multi channel MIDI step sequencer LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
