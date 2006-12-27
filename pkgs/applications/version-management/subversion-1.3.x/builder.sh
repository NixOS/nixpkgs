buildInputs="$openssl $zlib $db4 $httpd $swig $python $jdk $expat $patch"
source $stdenv/setup

configureFlags="--without-gdbm --disable-static"

if test "$localServer"; then
    configureFlags="--with-berkeley-db=$db4 $configureFlags"
fi

if test "$sslSupport"; then
    configureFlags="--with-ssl --with-libs=$openssl $configureFlags"
fi

if test "$httpServer"; then
    configureFlags="--with-apxs=$httpd/bin/apxs --with-apr=$httpd --with-apr-util=$httpd $configureFlags"
    makeFlags="APACHE_LIBEXECDIR=$out/modules $makeFlags"
else
    configureFlags="--without-apxs $configureFlags"
fi

if test -n "$pythonBindings"; then
    configureFlags="--with-swig=$swig $configureFlags"
fi

if test "$javahlBindings"; then
    configureFlags="--enable-javahl --with-jdk=$jdk $configureFlags"
fi


postInstall() {
    if test "$pythonBindings"; then
        make swig-py
        make install-swig-py
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
