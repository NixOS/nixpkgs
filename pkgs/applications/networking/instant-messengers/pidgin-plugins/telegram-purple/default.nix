{ stdenv, fetchgit, pkgconfig, pidgin, libwebp, libgcrypt, gettext } :

let
  version = "2016-03-17";
in
stdenv.mkDerivation rec {
  name = "telegram-purple-${version}";

  src = fetchgit {
    url = "https://github.com/majn/telegram-purple";
    rev = "ee2a6fb740fe9580336e4af9a153b845bc715927";
    sha256 = "0pxaj95b6nzy73dckpr3v4nljyijkx71vmnp9dcj48d22pvy0nyf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pidgin libwebp libgcrypt gettext ];

  preConfigure = ''
    sed -i "s|/etc/telegram-purple/server.tglpub|$out/lib/pidgin/server.tglpub|g" telegram-purple.c
  '';

  installPhase = ''
    mkdir -p $out/lib/pidgin/
    cp bin/*.so $out/lib/pidgin/
    cp tg-server.tglpub $out/lib/pidgin/server.tglpub
    mkdir -p $out/pixmaps/pidgin/protocols/{16,22,48}
    cp imgs/telegram16.png $out/pixmaps/pidgin/protocols/16
    cp imgs/telegram22.png $out/pixmaps/pidgin/protocols/22
    cp imgs/telegram48.png $out/pixmaps/pidgin/protocols/48
  '';

  meta = {
    homepage = https://github.com/majn/telegram-purple;
    description = "Telegram for Pidgin / libpurple";
    license = stdenv.lib.licenses.gpl2;
    maintainers = stdenv.lib.maintainers.jagajaga;
  };
}
