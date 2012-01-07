source $stdenv/setup

patchPhase=patchPhase
patchPhase() {
  sed -e "s@-ljpeg6b@-ljpeg@" -i configure
}

genericBuild

ln -sv $KDEDIR/share/mimelnk $out/share
