_prefix=/usr
_bindir=/usr/bin

PARAMETER=$1

if [ `uname -m` != "x86_64" ]
then
	_locallibs=/usr/local/lib
else
	_locallibs=/usr/local/lib64
fi

cd cngplp
if [ $PARAMETER = "-deb" ]
then
	./autogen.sh --prefix=${_prefix} --libdir=/usr/lib
else
	./autogen.sh --libdir=${_locallibs}
fi

cd files
./autogen.sh
cd ..
cd ..

cd driver  
./autogen.sh --prefix=${_prefix}  --enable-progpath=${_bindir} --disable-static
cd -

cd backend 
./autogen.sh --prefix=${_prefix}  --enable-progpath=${_bindir}
cd -

cd pstocapt 
./autogen.sh --prefix=${_prefix}  --enable-progpath=${_bindir}
cd -

cd pstocapt2
./autogen.sh --prefix=${_prefix}  --enable-progpath=${_bindir}
cd -

cd pstocapt3
./autogen.sh --prefix=${_prefix}  --enable-progpath=${_bindir}
cd -

cd ppd 
./autogen.sh --prefix=${_prefix} 
cd -

cd statusui
if [ -x /usr/bin/automake-1.6 ] ; then
	./autogen.sh
elif [ -x /usr/bin/automake-1.7 ] ; then
	./autogen.sh
elif [ -x /usr/bin/automake-1.8 ] ; then
	./autogen.sh
elif [ -x /usr/bin/automake-1.9 ] ; then
	./autogen.sh
else
	./autogen-old.sh
fi

cd -
make

