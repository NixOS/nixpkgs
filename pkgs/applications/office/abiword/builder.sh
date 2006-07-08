source $stdenv/setup

preConfigure() {
  cd abi
}

preConfigure=preConfigure

genericBuild
