{ stdenv, fetchFromGitHub, xorg, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "BSEQuencer";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = version;
    sha256 = "0hagnn104ybzdp13r95idw20fhmzif8p3kmiypnr20m6c64rdd29";
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
