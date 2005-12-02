source $stdenv/setup

if test -n "$freetype"; then
    configureFlags="\
      --with-freetype2-library=$freetype/lib \
      --with-freetype2-includes=$freetype/include/freetype2 \
      $configureFlags"
fi

genericBuild
