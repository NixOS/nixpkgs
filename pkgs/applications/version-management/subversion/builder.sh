buildInputs="$openssl $db4 $httpd $swig $python $expat"
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

if test "$swigBindings"; then
    configureFlags="--with-swig=$swig $configureFlags"
fi

installFlags="$makeFlags"


postInstall() {
    if test "$swigBindings"; then
        make swig-py
        make install-swig-py
    fi
}
postInstall=postInstall


genericBuild
