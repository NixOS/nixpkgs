source $stdenv/setup

export nodep=TRUE
export NO_HIDS=TRUE

export PATH=$icu/sbin:$PATH

preConfigure=preConfigure
preConfigure() {
    for i in \
	sysui/desktop/share/makefile.mk \
	; do 
	substituteInPlace $i --replace /bin/bash /bin/sh
    done

    cd config_office/
}

postConfigure="cd .."

buildPhase=buildPhase
buildPhase() {
  source LinuxX86Env.Set.sh
  ./bootstrap

  dmake
}

genericBuild
