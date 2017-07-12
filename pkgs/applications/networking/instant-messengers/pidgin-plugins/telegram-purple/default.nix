{ stdenv, fetchFromGitHub, pkgconfig, pidgin, libwebp, libgcrypt, gettext } :

let
  version = "1.3.0";
in
stdenv.mkDerivation rec {
  name = "telegram-purple-${version}";

  src = fetchFromGitHub {
    owner = "majn";
    repo = "telegram-purple";
    rev = "0340e4f14b2480782db4e5b9242103810227c522";
    sha256 = "0hncb976hn22abyja9hgq5waycwg1kvfqjg7ikl21bjarzw696b4";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pidgin libwebp libgcrypt gettext ];

  preConfigure = ''
    sed -i "s|/etc/telegram-purple/server.tglpub|$out/lib/pidgin/server.tglpub|g" telegram-purple.c
    echo "#define GIT_COMMIT \"${builtins.substring 0 10 src.rev}\"" > commit.h
  '';

  installPhase = ''
    mkdir -p $out/lib/pidgin/
    cp bin/*.so $out/lib/pidgin/ #*/
    cp tg-server.tglpub $out/lib/pidgin/server.tglpub
    mkdir -p $out/pixmaps/pidgin/protocols/{16,22,48}
    cp imgs/telegram16.png $out/pixmaps/pidgin/protocols/16
    cp imgs/telegram22.png $out/pixmaps/pidgin/protocols/22
    cp imgs/telegram48.png $out/pixmaps/pidgin/protocols/48
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/majn/telegram-purple;
    description = "Telegram for Pidgin / libpurple";
    license = licenses.gpl2;
    maintainers = [ maintainers.jagajaga ];
    platforms = platforms.linux;
  };
}
