source $stdenv/setup

configurePhase() {
  cd config_office/;
  ./configure --disable-epm --disable-odk --with-java=no --disable-cups --with-system-libs --with-system-python --disable-mozilla --without-nas --disable-pasf --disable-gnome-vfs;
}

configurePhase=configurePhase;

genericBuild
