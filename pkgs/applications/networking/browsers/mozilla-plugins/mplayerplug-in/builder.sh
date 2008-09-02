source $stdenv/setup

# The Firefox pkgconfig files are buggy; they are called firefox-*.pc,
# but they refer to mozilla-*.pc.  Also, mplayerplug-in requires
# mozilla-*.pc.
mkdir pkgconfig
for i in $firefox/lib/pkgconfig/*.pc; do
    ln -s $i pkgconfig/$(echo $(basename $i) | sed s/firefox/mozilla/)
done
PKG_CONFIG_PATH=$NIX_BUILD_TOP/pkgconfig:$PKG_CONFIG_PATH

firefoxIncl=$(echo $firefox/include/firefox-*)
export NIX_CFLAGS_COMPILE="-I$firefoxIncl $NIX_CFLAGS_COMPILE"

installPhase() {
    ensureDir $out/lib/mozilla/plugins
    cp -p mplayerplug-in*.so mplayerplug-in*.xpt $out/lib/mozilla/plugins
}

genericBuild

