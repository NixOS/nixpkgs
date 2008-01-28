source $stdenv/setup

if test "$httpServer"; then
    makeFlags="APACHE_LIBEXECDIR=$out/modules $makeFlags"
fi


postInstall() {
    if test "$pythonBindings"; then
        make swig-py swig_pydir=$(toPythonPath $out)
        make install-swig-py swig_pydir=$(toPythonPath $out)
    fi
    if test "$perlBindings"; then
        make swig-pl-lib
        make install-swig-pl-lib
        cd subversion/bindings/swig/perl/native
        perl Makefile.PL PREFIX=$out
        make install
        cd -
    fi
    if test "$javahlBindings"; then
        mkdir -p subversion/bindings/java/javahl/classes # bug fix
        make javahl
        make install-javahl
        # Hack to prevent java.lang.UnsatisfiedLinkError: no svnjavahl in java.library.path
        cd $out/lib
        ln -s libsvnjavahl-1.so libsvnjavahl.so
        cd -
        mkdir -p $out/share/doc/$name
        $jdk/bin/javadoc -d $out/share/doc/$name \
            -windowtitle "JavaHL Subversion Bindings" \
            -link http://java.sun.com/j2se/1.4.2/docs/api/ \
            subversion/bindings/java/javahl/src/org/tigris/subversion/javahl/*.java
    fi
}
postInstall=postInstall


genericBuild
