source $stdenv/setup

patchPhase=patchPhase
patchPhase() {
  sed -e "s@-ljpeg6b@-ljpeg@" configure > configure.patched
  mv configure.patched configure
  chmod u+x configure
}

genericBuild

ln -s $KDEDIR/share/mimelnk $out/share