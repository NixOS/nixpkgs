addSDLPath () {
  if [ -e "$1/include/SDL" ]; then
    export SDL_PATH="${SDL_PATH-}${SDL_PATH:+ }$1/include/SDL"
    # NB this doesn’t work with split dev packages because different packages
    # will contain "include/SDL/" and "lib/" directories.
    #
    # However the SDL_LIB_PATH is consumed by SDL itself and serves to locate
    # libraries like SDL_mixer, SDL_image, etc which are not split-package
    # so the check above will only trigger on them.
    if [ -e "$1/lib" ]; then
      export SDL_LIB_PATH="${SDL_LIB_PATH-}${SDL_LIB_PATH:+ }-L$1/lib"
    fi
  fi
}

addEnvHooks "$hostOffset" addSDLPath
