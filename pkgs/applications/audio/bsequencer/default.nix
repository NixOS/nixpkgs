{ stdenv, fetchFromGitHub, xorg, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "BSEQuencer";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = "${version}";
    sha256 = "1fz0p0ba00b7k7a8q9mxwj01jwl8xwh9a2npn00pbbdrg9zv4fdr";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    xorg.libX11 cairo lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sjaehn/BSEQuencer";
    description = "Multi channel MIDI step sequencer LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
