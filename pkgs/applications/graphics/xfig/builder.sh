source $stdenv/setup
source $makeWrapper

makeFlags="XAWLIB=-lXaw3d BINDIR=$out/bin XAPPLOADDIR=$out/etc/X11/app-defaults LIBDIR=$out/lib/X11 XFIGDOCDIR=$out/share/doc/xfig MANPATH=$out/man"

preBuild=preBuild
preBuild() {
    echo "#define XAW3D" >> Imakefile.tmp
    echo "#define XAW3D1_5E" >> Imakefile.tmp
    cat Imakefile >> Imakefile.tmp
    mv Imakefile.tmp Imakefile
    xmkmf
}

dontMakeInstall=1
preInstall=preInstall
preInstall() {
    make install.all $makeFlags

    mv $out/bin/xfig $out/bin/.xfig

    makeWrapper $out/bin/.xfig $out/bin/xfig \
        --set XAPPLRESDIR $out/etc/X11/app-defaults
}

genericBuild
