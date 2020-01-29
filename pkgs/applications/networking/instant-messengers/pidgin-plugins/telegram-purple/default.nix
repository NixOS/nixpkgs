{ stdenv, fetchgit, pkgconfig, pidgin, libwebp, libgcrypt, gettext } :

let
  version = "1.3.1";
in
stdenv.mkDerivation rec {
  pname = "telegram-purple";
  inherit version;

  src = fetchgit {
    url = "https://github.com/majn/telegram-purple";
    rev = "v${version}";
    sha256 = "0p93jpjpx7hszwffzgixw04zkrpsiyzz4za3gfr4j07krc4771fp";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=cast-function-type";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pidgin libwebp libgcrypt gettext ];

  preConfigure = ''
    sed -i "s|/etc/telegram-purple/server.tglpub|$out/lib/purple-2/server.tglpub|g" telegram-purple.c
    echo "#define GIT_COMMIT \"${builtins.substring 0 10 src.rev}\"" > commit.h
  '';

  installPhase = ''
    mkdir -p $out/lib/purple-2/
    cp bin/*.so $out/lib/purple-2/ #*/
    cp tg-server.tglpub $out/lib/purple-2/server.tglpub
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
