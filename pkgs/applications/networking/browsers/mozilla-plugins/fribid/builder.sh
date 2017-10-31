source $stdenv/setup
export PREFIX=$out
configureFlags="--plugin-path=$out/lib/mozilla/plugins"
genericBuild
