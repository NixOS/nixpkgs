source $stdenv/setup

configurePhase() {

  cd config_office/;
  ./configure --disable-epm --disable-odk --with-java=no --disable-cups --with-system-python \
  --disable-mozilla --without-nas --disable-pasf --disable-gnome-vfs \
  --with-system-libs;

  cd ..
}

configurePhase=configurePhase

buildPhase() {
  ./bootstrap
  source LinuxIntelEnv.Set.sh 
  dmake
}

buildPhase=buildPhase

genericBuild
