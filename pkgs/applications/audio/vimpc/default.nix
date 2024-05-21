{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, libmpdclient
, ncurses
, pcre
, pkg-config
, taglib
, curl
}:

stdenv.mkDerivation rec {
  version = "0.09.2";
  pname = "vimpc";

  src = fetchFromGitHub {
    owner = "boysetsfrog";
    repo = "vimpc";
    rev = "v${version}";
    sha256 = "0lswzkap2nm7v5h7ppb6a64cb35rajysd09nb204rxgrkij4m6nx";
  };

  patches = [
    # Pull fix pending upstream inclusion for ncurses-6.3:
    #  https://github.com/boysetsfrog/vimpc/pull/100
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/boysetsfrog/vimpc/commit/055ecdce0720fdfc9ec2528c520b6c33da36271b.patch";
      sha256 = "01p858jjxm0bf8hnk1z8h45j8c1y9i995mafa6ff3vg9vlak61pv";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libmpdclient ncurses pcre taglib curl ];

  postInstall = ''
    mkdir -p $out/etc
    cp doc/vimpcrc.example $out/etc
  '';

  meta = with lib; {
    description = "A vi/vim inspired client for the Music Player Daemon (mpd)";
    homepage = "https://github.com/boysetsfrog/vimpc";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
    mainProgram = "vimpc";
  };
}
