{ stdenv, fetchFromGitHub, libX11, cairo, lv2, pkgconfig, libsndfile }:

stdenv.mkDerivation rec {
  pname = "BJumblr";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = version;
    sha256 = "03x1gvri9yk000fvvc8zvvywf38cc41vkyhhp9xby71b23n5wbn0";
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
