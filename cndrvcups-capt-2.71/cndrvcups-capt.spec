%define	VERSION	2.71
%define COMMON_VERSION 3.21
%define	README_VERSION	2.71
%define	 RELEASE 1

%ifarch x86_64
%define libs32	/usr/lib
%define LIBS		libs64
%define locallibs      /usr/local/lib64
%else
%define libs32	%{_libdir}
%define LIBS		libs
%define locallibs      /usr/local/lib
%endif

Summary: Canon CAPT Printer Driver for Linux v%{VERSION}
Name: cndrvcups-capt
Version: %{VERSION}
Release: %{RELEASE}
License: See the LICENSE*.txt file.
# Copyright: Copyright CANON INC. 2004. All Rights Reserved.
Vendor: CANON INC.
Group: Applications/Publishing

Source: cndrvcups-capt-%{version}-%{release}.tar.gz

BuildRoot: %{_tmppath}/%{name}-root
Requires: cndrvcups-common >= %{COMMON_VERSION} libxml2 
BuildRequires: cndrvcups-common >= %{COMMON_VERSION} libxml2-devel

%description
Canon CAPT Printer Driver for Linux. 
This CAPT printer driver provides printing functions for Canon LBP printers
operating under the CUPS (Common UNIX Printing System) environment.

%prep

%setup -q 

cd driver 
./autogen.sh --prefix=%{_prefix} --libdir=%{_libdir} --enable-progpath=%{_bindir} --disable-static
cd -
cd backend 
./autogen.sh --prefix=%{_prefix} --libdir=%{_libdir} --enable-progpath=%{_bindir}
cd -
cd pstocapt 
./autogen.sh --prefix=%{_prefix} --libdir=%{_libdir} --enable-progpath=%{_bindir}
cd -
cd pstocapt2 
./autogen.sh --prefix=%{_prefix} --libdir=%{_libdir} --enable-progpath=%{_bindir}
cd -
cd pstocapt3 
./autogen.sh --prefix=%{_prefix} --libdir=%{_libdir} --enable-progpath=%{_bindir}
cd -
cd ppd 
./autogen.sh --prefix=%{_prefix} 
cd -
cd statusui
./autogen.sh --libdir=%{_libdir} 

cd -
cd cngplp
./autogen.sh --libdir=%{locallibs}

cd files
./autogen.sh
cd ..
cd ..

%build
make

%install
mkdir -pv ${RPM_BUILD_ROOT}%{_bindir}
mkdir -pv ${RPM_BUILD_ROOT}%{_sbindir}
mkdir -pv ${RPM_BUILD_ROOT}%{_prefix}/local/bin
mkdir -pv ${RPM_BUILD_ROOT}%{_libdir}/cups/backend
mkdir -pv ${RPM_BUILD_ROOT}%{_libdir}/cups/filter
mkdir -pv ${RPM_BUILD_ROOT}%{_prefix}/local/share/locale/ja/LC_MESSAGES
mkdir -pv ${RPM_BUILD_ROOT}%{_datadir}/captfilter
mkdir -pv ${RPM_BUILD_ROOT}%{_datadir}/ccpd
mkdir -pv ${RPM_BUILD_ROOT}%{_datadir}/captmon
mkdir -pv ${RPM_BUILD_ROOT}%{_datadir}/captmon2
mkdir -pv ${RPM_BUILD_ROOT}%{_datadir}/captemon
mkdir -pv ${RPM_BUILD_ROOT}%{_datadir}/cups/model
mkdir -pv ${RPM_BUILD_ROOT}%{_datadir}/doc/%{name}-%{version}/JP
mkdir -pv ${RPM_BUILD_ROOT}%{_datadir}/doc/%{name}-%{version}/EN
mkdir -pv ${RPM_BUILD_ROOT}/etc/init.d
mkdir -pv ${RPM_BUILD_ROOT}%{_prefix}/share/caepcm
mkdir -pv ${RPM_BUILD_ROOT}%{libs32}
# cngplp
mkdir -pv ${RPM_BUILD_ROOT}%{locallibs}
mkdir -pv ${RPM_BUILD_ROOT}%{_prefix}/share/cngplp

make install DESTDIR=${RPM_BUILD_ROOT}

install -c -s -m 755 libs/captmon/captmon       	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captmon2/captmon2    	 	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captfilter    		${RPM_BUILD_ROOT}%{_bindir}
install -c    -m 755 libs/ccpddata/CNAB1CL.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNAC4CL.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNAC5CL.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNAC6CL.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNAB7CL.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/cnab6cl.bin   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNAC8CL.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNAC9CL.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNAC9CLS.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNABBCL.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNABBCLS.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNABECL.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNACACL.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNACBCL.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNACCCL.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNABGCL.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/ccpddata/CNACDCL.BIN   	${RPM_BUILD_ROOT}%{_datadir}/ccpd
install -c    -m 755 libs/captmon/msgtable.xml   	${RPM_BUILD_ROOT}%{_datadir}/captmon
install -c    -m 755 libs/captmon2/msgtable2.xml  	${RPM_BUILD_ROOT}%{_datadir}/captmon2
install -c -s -m 755 %{LIBS}/ccpd          		${RPM_BUILD_ROOT}%{_sbindir}
install -c -s -m 755 %{LIBS}/ccpdadmin     		${RPM_BUILD_ROOT}%{_sbindir}
install -c    -m 755 samples/ccpd.conf   		${RPM_BUILD_ROOT}/etc
install -c    -m 755 samples/ccpd        		${RPM_BUILD_ROOT}/etc/init.d

install -c -s -m 755 libs/captemon/captmonlbp5000      	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmonlbp3300      	${RPM_BUILD_ROOT}%{_bindir}
install -c    -m 755 libs/captemon/msgtablelbp5000.xml  ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablelbp3300.xml  ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c -s -m 755 libs/captemon/captmoncnac5        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnac6        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnac8        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnac9        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnab6        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnab7        	${RPM_BUILD_ROOT}%{_bindir}
install -c    -m 755 libs/captemon/msgtablecnac5.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnac6.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnab6.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnab7.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c -s -m 755 libs/captemon/captmoncnab8        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnab9        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnaba        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnabb        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnabc        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnabd        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnabe        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnaca        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnacb        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnacc        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnabf        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnabg        	${RPM_BUILD_ROOT}%{_bindir}
install -c -s -m 755 libs/captemon/captmoncnacd        	${RPM_BUILD_ROOT}%{_bindir}
install -c    -m 755 libs/captemon/msgtablecnab8.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnab9.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnaba.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnac8.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnac9.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnabb.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnabc.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnabd.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnabe.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnaca.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnacb.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnacc.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnabf.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnabg.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon
install -c    -m 755 libs/captemon/msgtablecnacd.xml    ${RPM_BUILD_ROOT}%{_datadir}/captemon

#install -c    -m 644 data/CNL8*	${RPM_BUILD_ROOT}%{_prefix}/share/caepcm
#install -c    -m 644 data/CNL7*	${RPM_BUILD_ROOT}%{_prefix}/share/caepcm
#install -c    -m 644 data/CNL9*	${RPM_BUILD_ROOT}%{_prefix}/share/caepcm
#install -c    -m 644 data/CNLA*	${RPM_BUILD_ROOT}%{_prefix}/share/caepcm
#install -c    -m 644 data/CNLC*	${RPM_BUILD_ROOT}%{_prefix}/share/caepcm
#install -c    -m 644 data/CNLE*	${RPM_BUILD_ROOT}%{_prefix}/share/caepcm
install -c    -m 644 data/CnA*	${RPM_BUILD_ROOT}%{_prefix}/share/caepcm

install -c -s -m 755 libs/libcaptfilter.so.1.0.0	${RPM_BUILD_ROOT}%{libs32}
install -c    -m 755 libs/libcaiocaptnet.so.1.0.0	${RPM_BUILD_ROOT}%{libs32}
install -c    -m 755 libs/libcncaptnpm.so.2.0.1		${RPM_BUILD_ROOT}%{libs32}
install -c    -m 755 libs/captdrv			${RPM_BUILD_ROOT}%{_bindir}

install -c    -m 755 libs/CnA*INK.DAT   		${RPM_BUILD_ROOT}%{_datadir}/captfilter
install -c    -m 755 libs/captemon/CNAC*.BIN		${RPM_BUILD_ROOT}%{_datadir}/ccpd

install -c 	-m 755 libs/libcnaccm.so.1.0		${RPM_BUILD_ROOT}%{libs32}

cd ${RPM_BUILD_ROOT}%{libs32}
ln -sf libcaiocaptnet.so.1.0.0	libcaiocaptnet.so.1
ln -sf libcaiocaptnet.so.1.0.0	libcaiocaptnet.so
ln -sf libcncaptnpm.so.2.0.1	libcncaptnpm.so.2
ln -sf libcncaptnpm.so.2.0.1	libcncaptnpm.so
ln -sf libcaptfilter.so.1.0.0	libcaptfilter.so.1
ln -sf libcaptfilter.so.1.0.0	libcaptfilter.so
ln -sf libcnaccm.so.1.0		libcnaccm.so.1
ln -sf libcnaccm.so.1.0		libcnaccm.so
cd -

%clean
rm -rf $RPM_BUILD_ROOT

%pre
/etc/init.d/ccpd stop > /dev/null 2>&1
while [ `ps awx | grep -e ccpd -e captmon | grep -v grep | wc -l` -ne 0 ]
do
	kill -9 `ps awx | grep -e ccpd -e captmon | grep -v grep | cut -c 1-5` > /dev/null 2>&1
	sleep 3
done

%post
#if [ ! -d /var/ccpd ] ; then
#	mkdir /var/ccpd
#	mkfifo -m 600 /var/ccpd/fifo0
#	mkfifo -m 600 /var/ccpd/fifo1
#	mkfifo -m 600 /var/ccpd/fifo2
#	mkfifo -m 600 /var/ccpd/fifo3
#	mkfifo -m 600 /var/ccpd/fifo4
#	mkfifo -m 600 /var/ccpd/fifo5
#	mkfifo -m 600 /var/ccpd/fifo6
#	mkfifo -m 600 /var/ccpd/fifo7
#
#	chown lp.lp /var/ccpd/*
#fi
if [ ! -d /var/captmon ] ; then
	mkdir /var/captmon
	chown lp.lp /var/captmon
fi

if [ -d /usr/lib64/cups ]; then
	if [ -d /usr/lib/cups ]; then
		cd /usr/lib/cups/backend
		ln -sf ../../../lib64/cups/backend/ccp ccp
		cd /usr/lib/cups/filter
		ln -sf ../../../lib64/cups/filter/pstocapt  pstocapt
		ln -sf ../../../lib64/cups/filter/pstocapt2 pstocapt2
		ln -sf ../../../lib64/cups/filter/pstocapt3 pstocapt3
	fi
fi

if [ -x /sbin/ldconfig ]; then
	/sbin/ldconfig
fi

# /sbin/chkconfig --add ccpd

%preun
# if [ "$1" = 0 ] ; then
#	/sbin/service ccpd stop > /dev/null 2>&1
#	/sbin/chkconfig --del ccpd
# fi
# exit 0
/etc/init.d/ccpd stop > /dev/null 2>&1
while [ `ps awx | grep -e ccpd -e captmon | grep -v grep | wc -l` -ne 0 ]
do
	kill -9 `ps awx | grep -e ccpd -e captmon | grep -v grep | cut -c 1-5` > /dev/null 2>&1
	sleep 3
done

%postun
if [ "$1" = 0 ] ; then
#	rm -Rf /var/ccpd
	rm -Rf /var/captmon
	rm -Rf %{_datadir}/captfilter
	rm -Rf %{_datadir}/captmon
	rm -Rf %{_datadir}/captmon2
	rm -Rf %{_datadir}/captemon
	rm -Rf %{_datadir}/ccpd
# else
#	/sbin/service ccpd restart > /dev/null 2>&1
fi

if [ $1 = 0 ]; then
	if [ -d /usr/lib64/cups ]; then
		if [ -d /usr/lib/cups ]; then
			cd /usr/lib/cups/backend
			rm -f ccp
			cd /usr/lib/cups/filter
			rm -f pstocapt
			rm -f pstocapt2
			rm -f pstocapt3
		fi
	fi
fi

if [ -x /sbin/ldconfig ]; then
	/sbin/ldconfig
fi

%files
%defattr(-,root,root)

%{_libdir}/cups/backend/ccp
%{_libdir}/cups/filter/pstocapt
%{_libdir}/cups/filter/pstocapt2
%{_libdir}/cups/filter/pstocapt3
%{_libdir}/libcanoncapt.*
%{_prefix}/local/bin/captstatusui
%{_prefix}/local/share/locale/ja/LC_MESSAGES/captstatusui.mo
%{_datadir}/cups/model/CNCUPS*CAPT*.ppd
%{_datadir}/ccpd/CNA*CL.BIN
%{_datadir}/ccpd/CNA*CLS.BIN
%{_datadir}/ccpd/cn*.bin
%{_datadir}/captmon/msgtable.xml
%{_datadir}/captmon2/msgtable2.xml
%{_bindir}/captmon
%{_bindir}/captmon2
%{_bindir}/captfilter
%{_sbindir}/ccpd
%{_sbindir}/ccpdadmin
%{_bindir}/captmonlbp5000
%{_bindir}/captmonlbp3300
%{_bindir}/captmoncn*
%{_datadir}/captemon/msgtablelbp5000.xml
%{_datadir}/captemon/msgtablelbp3300.xml
%{_datadir}/captemon/msgtablecnab*.xml
%{_datadir}/captemon/msgtablecnac*.xml

%{_datadir}/captfilter/CnA*INK.DAT
%{_datadir}/ccpd/CNA*CR.BIN
%{_datadir}/ccpd/CNA*DH.BIN

%{_prefix}/share/caepcm/C*

%{_bindir}/captdrv
%{libs32}/libcaptfilter.so*
%{libs32}/libcaiocaptnet.so*
%{libs32}/libcncaptnpm.so*
%{libs32}/libcnaccm.so*

# cngplp
%{locallibs}/libuictlcapt.*
%{_prefix}/share/cngplp/cngplp_capt.glade
%{_prefix}/share/cngplp/*.res
%{_prefix}/share/cngplp/func_config_capt.xml
%{_prefix}/local/share/locale/ja/LC_MESSAGES/libuictlcapt*.mo
%{_prefix}/local/share/locale/fr/LC_MESSAGES/libuictlcapt*.mo
%{_prefix}/local/share/locale/it/LC_MESSAGES/libuictlcapt*.mo
%{_prefix}/local/share/locale/de/LC_MESSAGES/libuictlcapt*.mo
%{_prefix}/local/share/locale/es/LC_MESSAGES/libuictlcapt*.mo
#

#%config(noreplace) /etc/ccpd.conf
%config		/etc/ccpd.conf
%config		/etc/init.d/ccpd

%doc README-capt-%{README_VERSION}UK.txt
%doc README-capt-%{README_VERSION}US.txt
%doc README-capt-%{README_VERSION}J.txt
%doc LICENSE-EN.txt
%doc LICENSE-JP.txt
