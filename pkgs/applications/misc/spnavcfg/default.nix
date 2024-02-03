{ stdenv, lib, fetchFromGitHub, pkg-config, gtk2 }:

stdenv.mkDerivation rec {
  pname = "spnavcfg";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = pname;
    rev = "v${version}";
    sha256 = "180mkdis15gxs79rr3f7hpwa1p6v81bybw37pzzdjnmqwqrc08a0";
  };

  patches = [
    # Changes the pidfile path from /run/spnavd.pid to $XDG_RUNTIME_DIR/spnavd.pid
    # to allow for a user service
    ./configure-pidfile-path.patch
    # Changes the config file path from /etc/spnavrc to $XDG_CONFIG_HOME/spnavrc or $HOME/.config/spnavrc
    # to allow for a user service
    ./configure-cfgfile-path.patch
  ];

  postPatch = ''
    sed -i s/4775/775/ Makefile.in
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = with lib; {
    homepage = "https://spacenav.sourceforge.net/";
    description = "Interactive configuration GUI for space navigator input devices";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
