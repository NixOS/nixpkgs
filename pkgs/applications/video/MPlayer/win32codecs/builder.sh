. $stdenv/setup

mkdir $out
cd $out
tar xvfj $src
mv extralite/* .
rmdir extralite
