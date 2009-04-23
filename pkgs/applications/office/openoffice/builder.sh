source $stdenv/setup

export nodep=TRUE
export NO_HIDS=TRUE

export PATH=$icu/sbin:$PATH

postUnpack=postUnpack
postUnpack() {
  tar xvjf $src_system
}

preConfigure=preConfigure
preConfigure() {
    for i in sysui/desktop/share/makefile.mk; do 
	substituteInPlace $i --replace /bin/bash $shell
    done

    SRCDIR=

    sed -e '/CURL_NO_OLDIES/d' -i ucb/source/ucp/ftp/makefile.mk

    cd config_office/
}


postConfigure=postConfigure
postConfigure() {
    cd ..
    for i in LinuxX86*Env.Set; do
	substituteInPlace $i --replace /usr /no-such-path
    done
    substituteInPlace solenv/inc/libs.mk \
	--replace /usr/lib/libjpeg.so $libjpeg/lib/libjpeg.so \
	--replace /usr/lib64/libjpeg.so $libjpeg/lib/libjpeg.so
}


buildPhase=buildPhase
buildPhase() {
    source LinuxX86*Env.Set.sh
    ./bootstrap
    dmake # wait a few hours...
}


wrapSOffice() {
    local fn=$1
    local arg=$2

    # !!! should use makeWrapper for this.

    cat > $out/bin/$fn <<EOF 
#! $shell
# Add fontconfig to the library search path; apparently OpenOffice
# looks for it at runtime.
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH\${LD_LIBRARY_PATH:+:}$fontconfig/lib:$libjpeg/lib:$cups/lib
export JAVA_HOME=$jdk
exec $ooFiles/openoffice.org3/program/soffice $arg "\$@"
EOF
    chmod +x $out/bin/$fn
}


installPhase=installPhase
installPhase() {
    ooFiles=$out/lib/openoffice

    # This was all borrowed from ooo-build-2.2.1's bin/ooinstall.
    eval $(grep 'BUILD\|LAST_MINOR' $SOLARENV/inc/minor.mk)
    export PYTHONPATH=$SOLARVERSION/$INPATH/lib:$SRC_ROOT/instsetoo_native/$INPATH/bin:$PYTHONPATH 
    export OUT=../$INPATH
    export LOCAL_OUT=../$INPATH
    export LOCAL_COMMON_OUT=../$INPATH

    # Do the actual installation into $out.
    (cd $SRC_ROOT/instsetoo_native/util && perl -w $SOLARENV/bin/make_installer.pl \
	-f openoffice.lst -l en-US -p OpenOffice \
	-buildid $BUILD -simple $ooFiles)

    ensureDir $out/bin
    for i in soffice ooffice; do wrapSOffice $i; done
    
    # Create some wrappers to start individual OpenOffice components.
    for i in writer calc draw impress base math web; do wrapSOffice oo$i -$i; done
}


genericBuild

