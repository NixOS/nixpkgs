{ stdenv, lib, fetchFromGitHub, xorg, cairo, lv2, libsndfile, pkg-config }:

stdenv.mkDerivation rec {
  pname = "boops";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = "BOops";
    rev = version;
    sha256 = "0nvpawk58g189z96xnjs4pyri5az3ckdi9mhi0i9s0a7k4gdkarr";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorg.libX11 cairo lv2 libsndfile
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/sjaehn/BOops";
    description = "Sound glitch effect sequencer LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
