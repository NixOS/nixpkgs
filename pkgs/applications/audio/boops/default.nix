{ stdenv, lib, fetchFromGitHub, xorg, cairo, lv2, libsndfile, pkg-config }:

stdenv.mkDerivation rec {
  pname = "boops";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = "BOops";
    rev = version;
    sha256 = "sha256-7eNvt8PxIZCp83Y5XX5fBolBon4j+HPtu8wrgG8Miok=";
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
