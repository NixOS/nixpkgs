addSDL2Path () {
  if [ -e "$1/include/SDL2" ]; then
    export SDL2_PATH="${SDL2_PATH-}${SDL2_PATH:+ }$1/include/SDL2"
  fi
}

addEnvHooks "$hostOffset" addSDL2Path
