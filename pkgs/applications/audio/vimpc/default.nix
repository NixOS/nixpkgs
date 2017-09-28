{ stdenv, fetchFromGitHub, autoreconfHook, mpd_clientlib, ncurses, pcre, pkgconfig
, taglib }:

stdenv.mkDerivation rec {
  version = "0.09.0";
  name = "vimpc-${version}";

  src = fetchFromGitHub {
    owner = "boysetsfrog";
    repo = "vimpc";
    rev = "v${version}";
    sha256 = "1z9yx2pz84lyng1ig9y4z6pdalwxb80ig7nnzhqfy3pl36hq6shi";
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
