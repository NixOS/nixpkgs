. $stdenv/setup || exit 1

mkdir $out || exit 1
cd $out || exit 1
tar xvfj $src || exit 1
mv extralite/* . || exit 1
rmdir extralite || exit 1
