buildInputs="$openssl $db4 $httpd $swig $python $j2sdk $expat $patch"
. $stdenv/setup

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
fi

if test "$pythonBindings"; then
    configureFlags="--with-swig=$swig $configureFlags"
fi

if test "$javaBindings"; then
    configureFlags="--enable-javahl --with-jdk=$j2sdk $configureFlags"
fi

installFlags="$makeFlags"


postInstall() {
    if test "$pythonBindings"; then
        make swig-py
        make install-swig-py
    fi
    if test "$javaBindings"; then
        mkdir subversion/bindings/java/javahl/classes # bug fix
        make javahl
        make install-javahl
    fi
}
postInstall=postInstall


genericBuild
