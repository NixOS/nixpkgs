#! /bin/sh

export PATH=/bin:/usr/bin

export LDFLAGS=-s

top=`pwd`

if test $httpsClient; then
    extraflags="--with-ssl --with-libs=$ssl $extraflags"
fi

if test $httpServer; then
    extraflags="--with-apxs=$httpd/bin/apxs --with-apr=$httpd --with-apr-util=$httpd $extraflags"
    extrainst="APACHE_LIBEXECDIR=$top/modules $extrainst"
fi

echo "extra flags: $extraflags"

tar xvfz $src || exit 1
cd subversion-* || exit 1
./configure --prefix=$top $extraflags || exit 1
make || exit 1
make install $extrainst || exit 1
cd $top || exit 1
rm -rf subversion-* || exit 1
