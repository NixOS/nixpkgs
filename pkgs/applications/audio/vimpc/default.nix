{ stdenv, fetchFromGitHub, autoreconfHook, mpd_clientlib, ncurses, pcre, pkgconfig
, taglib, curl }:

stdenv.mkDerivation rec {
  version = "0.09.2";
  name = "vimpc-${version}";

  src = fetchFromGitHub {
    owner = "boysetsfrog";
    repo = "vimpc";
    rev = "v${version}";
    sha256 = "0lswzkap2nm7v5h7ppb6a64cb35rajysd09nb204rxgrkij4m6nx";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ mpd_clientlib ncurses pcre taglib curl ];

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
