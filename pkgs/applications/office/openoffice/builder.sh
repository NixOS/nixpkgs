source $stdenv/setup

configurePhase() {
  cd config_office/;
  ./configure;
}

configurePhase=configurePhase;

genericBuild
