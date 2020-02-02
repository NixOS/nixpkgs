{ stdenv, lib, fetchFromGitHub, mpv }:

stdenv.mkDerivation rec {
  name = "mpv-plugin-bookmark-${version}.lua";
  version = "20180320";

  src = fetchFromGitHub {
    owner = "yozorayuki";
    repo = "mpv-plugin-bookmark";
    rev = "08fa0a415a4a220a91b8436ca681e3da92120b9d";
    sha256 = "0ann6c2rajy36a6w72l2q6288r6v03ha278i5qh5hk6r9q6gkhy8";
  };

  installPhase = ''
    cp bookmark.lua $out
  '';

  meta = with lib; {
    description = "mpv plugin to record your playing history for each folder and you can choose resume to play next time";
    homepage = https://github.com/yozorayuki/mpv-plugin-bookmark;
    license = licenses.asl20;
    maintainers = [ maintainers.mschneider ];
  };
}