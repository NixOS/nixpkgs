source "$stdenv/setup" || exit 1

configureFlags="--with-sdl-mixer-incl=$SDL_mixer/include/SDL --with-sdl-incl=$SDL/include/SDL --with-plugindir=$out/plugins --enable-gui=gtk"

genericBuild
