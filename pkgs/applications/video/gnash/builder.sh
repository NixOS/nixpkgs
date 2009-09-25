source "$stdenv/setup"

configureFlags="					\
  --with-sdl-incl=$SDL/include/SDL			\
  --with-npapi-plugindir=$out/plugins			\
  --enable-media=gst					\
  --enable-gui=gtk"

# In `libmedia', Gnash compiles with "-I$gstPluginsBase/include",
# whereas it really needs "-I$gstPluginsBase/include/gstreamer-0.10".
# Work around this using GCC's $CPATH variable.
export CPATH="$gstPluginsBase/include/gstreamer-0.10"

genericBuild
