#! /bin/sh

export PATH=$libxml/bin:/bin:/usr/bin:/usr/local/bin
export LD_LIBRARY_PATH=$ssl/lib:

export LDFLAGS=-s

top=`pwd`

if test $localServer; then
    extraflags="--with-berkeley-db=$db4 $extraflags"
fi

if test $httpsClient; then
    extraflags="--with-ssl --with-libs=$ssl $extraflags"
fi

if test $httpServer; then
    extraflags="--with-apxs=$httpd/bin/apxs --with-apr=$httpd --with-apr-util=$httpd $extraflags"
    extramakeflags="APACHE_LIBEXECDIR=$top/modules $extramakeflags"
fi

if test $pythonBindings; then
    extraflags="--with-swig=$swig $extraflags"
fi

echo "extra flags: $extraflags"

tar xvfz $src || exit 1
cd subversion-* || exit 1
./configure --prefix=$top $extraflags || exit 1
make $extramakeflags || exit 1
make install $extramakeflags || exit 1

if test $pythonBindings; then
    make swig-py || exit 1
    make install-swig-py || exit 1
fi

cd $top || exit 1
rm -rf subversion-* || exit 1
