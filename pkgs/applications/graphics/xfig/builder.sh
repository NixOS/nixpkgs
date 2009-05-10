source $stdenv/setup

makeFlags="XAWLIB=-lXaw3d BINDIR=$out/bin XAPPLOADDIR=$out/etc/X11/app-defaults LIBDIR=$out/lib/X11 XFIGDOCDIR=$out/share/doc/xfig MANPATH=$out/man"

preBuild() {
    echo "#define XAW3D" >> Imakefile.tmp
    echo "#define XAW3D1_5E" >> Imakefile.tmp
    cat Imakefile >> Imakefile.tmp
    mv Imakefile.tmp Imakefile
    xmkmf

    sed -e 's@[$][$]m@-- &@g' -i Makefile
}

installPhase() {
    make install.all $makeFlags

    wrapProgram $out/bin/xfig \
        --set XAPPLRESDIR $out/etc/X11/app-defaults
}

genericBuild
