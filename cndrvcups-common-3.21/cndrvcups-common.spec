%define VERSION 3.21
%define  RELEASE 1

%ifarch	x86_64
%define	libs32	/usr/lib
%define	locallibs	/usr/local/lib64
%else
%define	libs32	%{_libdir}
%define	locallibs	/usr/local/lib
%endif

Summary: Canon Printer Driver Common Module for Linux v%{VERSION}
Name: cndrvcups-common
Version: %{VERSION}
Release: %{RELEASE}
License: See the LICENSE*.txt file.
# Copyright: Copyright CANON INC. 2004
Vendor: CANON INC.
Group: Applications/Publishing

Source: cndrvcups-common-%{version}-%{release}.tar.gz

BuildRoot: %{_tmppath}/%{name}-root

%description

%prep
%setup -q

cd buftool
./autogen.sh --prefix=%{_prefix} --enable-progpath=%{_bindir} --libdir=%{_libdir} --disable-shared --enable-static

cd ../cngplp
./autogen.sh --libdir=%{locallibs} 

cd ../backend
./autogen.sh --prefix=%{_prefix} --libdir=%{_libdir}

%build
make

cd c3plmod_ipc
make 
cd -

%install
mkdir -pv ${RPM_BUILD_ROOT}%{_bindir}
mkdir -pv ${RPM_BUILD_ROOT}%{_prefix}/local/bin
mkdir -pv ${RPM_BUILD_ROOT}%{_libdir}
mkdir -pv ${RPM_BUILD_ROOT}%{_includedir}
mkdir -pv ${RPM_BUILD_ROOT}%{_prefix}/local/share/locale/ja/LC_MESSAGES
mkdir -pv ${RPM_BUILD_ROOT}%{_prefix}/share/caepcm
mkdir -pv ${RPM_BUILD_ROOT}%{libs32}
# cngplp
mkdir -pv ${RPM_BUILD_ROOT}%{_prefix}/share/cngplp/
#
mkdir -pv ${RPM_BUILD_ROOT}%{_libdir}/cups/backend/

make install DESTDIR=${RPM_BUILD_ROOT}

cd c3plmod_ipc
make install DESTDIR=${RPM_BUILD_ROOT} LIBDIR=%{_libdir}
cd - 

%ifarch x86_64
%define libsdir libsx86_64
%else
%define libsdir libs
%endif

install -c -m 755 libs/libcaiowrap.so.1.0.0		${RPM_BUILD_ROOT}%{libs32}
install -c -m 755 libs/libcaiousb.so.1.0.0		${RPM_BUILD_ROOT}%{libs32}

install -c -m 755 libs/libc3pl.so.0.0.1			${RPM_BUILD_ROOT}%{libs32}
install -c -m 755 libs/libcaepcm.so.1.0			${RPM_BUILD_ROOT}%{libs32}

install -c -m 755 libs/libColorGear.so.0.0.0    ${RPM_BUILD_ROOT}%{libs32}
install -c -m 755 libs/libColorGearC.so.0.0.0    ${RPM_BUILD_ROOT}%{libs32}

#install -c -m 644 data/CA*	${RPM_BUILD_ROOT}%{_prefix}/share/caepcm
#install -c -m 644 data/CNZ0*	${RPM_BUILD_ROOT}%{_prefix}/share/caepcm
install -c -m 644 data/*.ICC	${RPM_BUILD_ROOT}%{_prefix}/share/caepcm

install -c -s -m 755 libs/c3pldrv			${RPM_BUILD_ROOT}%{_bindir}

install -c -m 755 libs/libcanon_slim.so.1.0.0		${RPM_BUILD_ROOT}%{libs32}

cd ${RPM_BUILD_ROOT}%{libs32}
ln -sf libc3pl.so.0.0.1			libc3pl.so.0
ln -sf libc3pl.so.0.0.1			libc3pl.so
ln -sf libcaepcm.so.1.0			libcaepcm.so.1
ln -sf libcaepcm.so.1.0			libcaepcm.so
ln -sf libcaiowrap.so.1.0.0		libcaiowrap.so.1
ln -sf libcaiowrap.so.1.0.0		libcaiowrap.so
ln -sf libcaiousb.so.1.0.0		libcaiousb.so.1
ln -sf libcaiousb.so.1.0.0		libcaiousb.so
ln -sf libcanon_slim.so.1.0.0		libcanon_slim.so.1
ln -sf libcanon_slim.so.1.0.0		libcanon_slim.so
ln -sf libColorGear.so.0.0.0    libColorGear.so.0
ln -sf libColorGear.so.0.0.0    libColorGear.so
ln -sf libColorGearC.so.0.0.0   libColorGearC.so.0
ln -sf libColorGearC.so.0.0.0   libColorGearC.so
cd -

cd ${RPM_BUILD_ROOT}%{_libdir}
ln -sf libcanonc3pl.so.1.0.0		libcanonc3pl.so
ln -sf libcanonc3pl.so.1.0.0		libcanonc3pl.so.1

%clean
rm -rf $RPM_BUILD_ROOT

%pre

%post
if [ -d /usr/lib64/cups ]; then
	if [ -d /usr/lib/cups ]; then
		cd /usr/lib/cups/backend
		ln -sf ../../../lib64/cups/backend/cnusb cnusb
	fi
fi
if [ -x /sbin/ldconfig ]; then
	/sbin/ldconfig
fi

%postun
if [ "$1" = 0 ] ; then
	cd /etc
	rm -rf cngplp
	rm -rf %{_prefix}/share/cngplp/
	rm -rf %{_prefix}/share/caepcm/
fi
if [ $1 = 0 ]; then
	if [ -d /usr/lib64/cups ]; then
		if [ -d /usr/lib/cups ]; then
			cd /usr/lib/cups/backend
			rm -f cnusb
		fi
	fi
fi
if [ -x /sbin/ldconfig ]; then
	/sbin/ldconfig
fi

%files
%defattr(-,root,root)
%{_prefix}/local/share/locale/ja/LC_MESSAGES/cngplp.mo
%{_prefix}/local/share/locale/de/LC_MESSAGES/cngplp.mo
%{_prefix}/local/share/locale/es/LC_MESSAGES/cngplp.mo
%{_prefix}/local/share/locale/fr/LC_MESSAGES/cngplp.mo
%{_prefix}/local/share/locale/it/LC_MESSAGES/cngplp.mo
# cngplp
%{_prefix}/share/cngplp/cngplp.glade
#
%{_prefix}/local/bin/cngplp
%{_prefix}/local/bin/cnjatool
%{_libdir}/cups/backend/cnusb
%{_libdir}/libbuftool.a
%{_includedir}/buftool.h
%{_includedir}/buflist.h
%{_sysconfdir}/cngplp/account

%{libs32}/libcaiowrap.so*
%{libs32}/libcaiousb.so*

%{_libdir}/libcanonc3pl.so*
%{_bindir}/c3pldrv
%{libs32}/libc3pl.so*
%{libs32}/libcaepcm.so*
%{libs32}/libcanon_slim.so*

%{_prefix}/share/caepcm/C*
%{libs32}/libColorGear.so*
%{libs32}/libColorGearC.so*

%doc LICENSE-*.txt
