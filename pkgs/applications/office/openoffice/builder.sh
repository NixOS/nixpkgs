source $stdenv/setup

configurePhase() {

  cd config_office/;
  ./configure --disable-epm --disable-odk --with-java=no --disable-cups --with-system-python \
  --disable-mozilla --without-nas --disable-pasf --disable-gnome-vfs \
  --with-hsqldb-jar=$hsqldb/lib/hsqldb.jar \
  --with-beanshell-jar=$beanshell/bsh.jar \
  --with-xml-apis-jar=$xerces/xml-apis.jar \
  --with-xerces-jar=$xerces/xercesImpl.jar \
  --with-xalan-jar=$xalan/xalan.jar \
  --with-xt-jar=$xt --with-system-libs;
	
  #--with-system-libs

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
