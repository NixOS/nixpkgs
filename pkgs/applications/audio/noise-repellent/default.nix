{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, fftwFloat, lv2 }:

stdenv.mkDerivation rec {
  pname = "noise-repellent";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "lucianodato";
    repo = pname;
    rev = version;
    sha256 = "0hb89x9i2knzan46q4nwscf5zmnb2nwf4w13xl2c0y1mx1ls1mwl";
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
