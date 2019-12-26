{ stdenv, fetchFromGitHub, xorg, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "BShapr";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mi8f0svq1h9cmmxyskcazr5x2q4dls3j9jc6ahi5rlk7i0bpa74";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    xorg.libX11 cairo lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/sjaehn/BShapr;
    description = "Beat / envelope shaper LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
