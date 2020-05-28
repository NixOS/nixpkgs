{ stdenv, fetchFromGitHub, xorg, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "BShapr";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = "v${version}";
    sha256 = "04zd3a178i2nivg5rjailzqvc5mlnilmhj1ziygmbhshbrywplri";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    xorg.libX11 cairo lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sjaehn/BShapr";
    description = "Beat / envelope shaper LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
