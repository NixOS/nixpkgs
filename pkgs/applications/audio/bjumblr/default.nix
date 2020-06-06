{ stdenv, fetchFromGitHub, libX11, cairo, lv2, pkgconfig, libsndfile }:

stdenv.mkDerivation rec {
  pname = "BJumblr";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = "v${version}";
    sha256 = "14z8113zkwykbhm1a8h2xs972dgifvlfij92b08jckyc7cbz84ys";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libX11 cairo lv2 libsndfile
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sjaehn/BJumblr";
    description = "Pattern-controlled audio stream / sample re-sequencer LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
