#! /bin/sh

buildinputs="$openssl $db4 $httpd $swig $libxml2"
. $stdenv/setup || exit 1

if test $localServer; then
    extraflags="--with-berkeley-db=$db4 $extraflags"
fi

if test $sslSupport; then
    extraflags="--with-ssl --with-libs=$openssl $extraflags"
fi

if test $httpServer; then
    extraflags="--with-apxs=$httpd/bin/apxs --with-apr=$httpd --with-apr-util=$httpd $extraflags"
    extramakeflags="APACHE_LIBEXECDIR=$out/modules $extramakeflags"
else
    NIX_CFLAGS_COMPILE="-I$expat/include $NIX_CFLAGS_COMPILE"
    NIX_CFLAGS_LINK="-L$expat/lib $NIX_CFLAGS_LINK"
    NIX_LDFLAGS="-rpath $expat/lib $NIX_LDFLAGS"
fi

if test $swigBindings; then
    extraflags="--with-swig=$swig $extraflags"
fi

echo "extra flags: $extraflags"

tar xvfz $src || exit 1
cd subversion-* || exit 1
./configure --prefix=$out $extraflags \
 --without-gdbm --disable-static || exit 1
make $extramakeflags || exit 1
make install $extramakeflags || exit 1

if test $swigBindings; then
    make swig-py || exit 1
    make install-swig-py || exit 1
fi
