source $stdenv/setup

echo $with_jdk_home

export nodep=TRUE
export NO_HIDS=TRUE

export PATH=$icu/sbin:$PATH

preConfigure=preConfigure
preConfigure() {
    for i in \
	sysui/desktop/share/makefile.mk \
	; do 
	substituteInPlace $i --replace /bin/bash $shell
    done

    SRCDIR=

    cd config_office/
}


postConfigure="cd .."


buildPhase=buildPhase
buildPhase() {
    source LinuxX86Env.Set.sh
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
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH\${LD_LIBRARY_PATH:+:}$fontconfig/lib
exec $ooFiles/program/soffice $arg "\$@"
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
	-packagelist ../inc_openoffice/unix/packagelist.txt \
	-addpackagelist ../inc_openoffice/unix/packagelist_language.txt \
	-buildid $BUILD -simple $ooFiles)

    ensureDir $out/bin
    for i in soffice ooffice; do wrapSOffice $i; done
    
    # Create some wrappers to start individual OpenOffice components.
    for i in writer calc draw impress base math web; do wrapSOffice oo$i -$i; done
}


genericBuild

