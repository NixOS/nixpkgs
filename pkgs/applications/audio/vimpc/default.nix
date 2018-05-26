{ stdenv, fetchFromGitHub, autoreconfHook, mpd_clientlib, ncurses, pcre, pkgconfig
, taglib }:

stdenv.mkDerivation rec {
  version = "0.09.1";
  name = "vimpc-${version}";

  src = fetchFromGitHub {
    owner = "boysetsfrog";
    repo = "vimpc";
    rev = "v${version}";
    sha256 = "1495a702df4nja8mlxq98mkbic2zv88sjiinimf9qddrfb38jxk6";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ mpd_clientlib ncurses pcre taglib ];

  postInstall = ''
    mkdir -p $out/etc
    cp doc/vimpcrc.example $out/etc
  '';

  meta = with stdenv.lib; {
    description = "A vi/vim inspired client for the Music Player Daemon (mpd)";
    homepage = https://github.com/boysetsfrog/vimpc;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
