source "$stdenv/setup"

configureFlags="--with-sdl-incl=$SDL/include/SDL --with-npapi-plugindir=$out/plugins --enable-gui=gtk"

genericBuild
