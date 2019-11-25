{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, fftwFloat, lv2 }:

stdenv.mkDerivation rec {
  pname = "noise-repellent";
  version = "unstable-2018-12-29";

  src = fetchFromGitHub {
    owner = "lucianodato";
    repo = pname;
    rev = "9efdd0b41ec184a792087c87cbf5382f455e33ec";
    sha256 = "0pn9cxapfvb5l62q86bchyfll1290vi0rhrzarb1jpc4ix7kz53c";
    fetchSubmodules = true;
  };

  mesonFlags = ("--prefix=${placeholder "out"}/lib/lv2");

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [
    fftwFloat lv2
  ];

  meta = with stdenv.lib; {
    description = "An lv2 plugin for broadband noise reduction";
    homepage    = https://github.com/lucianodato/noise-repellent;
    license     = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "i686-darwin"  ];
  };
}
