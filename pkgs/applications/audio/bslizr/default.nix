{ stdenv, fetchFromGitHub, xorg, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "BSlizr";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = version;
    sha256 = "1f7xrljvsy7a1p8c7wln2zhwarl3ara7gbjxkpyh47wfdpigpdb0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    xorg.libX11 cairo lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sjaehn/BSlizr";
    description = "Sequenced audio slicing effect LV2 plugin (step sequencer effect)";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
