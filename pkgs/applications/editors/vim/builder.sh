source $stdenv/setup

postInstall=postInstall

postInstall() {
  ln -s $out/bin/vim $out/bin/vi
}

genericBuild
