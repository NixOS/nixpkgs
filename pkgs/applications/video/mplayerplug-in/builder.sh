buildinputs="$x11"
. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd mplayer* || exit 1
./configure || exit 1
make || exit 1
mkdir -p $out/lib/mozilla/plugins || exit 1
cp mplayerplug-in.so $out/lib/mozilla/plugins || exit 1
