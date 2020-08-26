{ stdenv, fetchFromGitHub, xorg, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "BSEQuencer";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = "${version}";
    sha256 = "0w21kzq695xy4i1r6xvvh7sad5m0rlmdgc7ykmrlzfsm1252dz80";
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
