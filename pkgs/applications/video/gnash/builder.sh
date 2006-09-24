source $stdenv/setup

configureFlags="--with-sdl-mixer-incl=$SDL_mixer/include/SDL --with-sdl-incl=$SDL/include/SDL --with-plugindir=$out/plugins"

genericBuild
