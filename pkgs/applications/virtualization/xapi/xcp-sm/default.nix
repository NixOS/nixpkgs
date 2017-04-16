{stdenv, xenserver-buildroot, fetchurl, pylint, swig, xen, xapi, python, mock}:

stdenv.mkDerivation {
  name = "xcp-sm-0.9.8.7b9e69";
  version = "0.9.8.7b9e69";

  src = fetchurl {
    url = "https://github.com/xapi-project/sm/archive/7b9e693d3759f053869d641cc10cc0ed4234bbcc/sm-0.9.8.7b9e69.tar.gz";
    sha256 = "1pns5mdqj3sillrag002pjvhrrs8zxagp0ksnmn532w8v8racshb";
  };

  patches = [ "${xenserver-buildroot}/usr/share/buildroot/SOURCES/xcp-sm-initiator-name.patch" "${xenserver-buildroot}/usr/share/buildroot/SOURCES/xcp-sm-pidof-path.patch" "${xenserver-buildroot}/usr/share/buildroot/SOURCES/xcp-sm-path-fix.patch" "${xenserver-buildroot}/usr/share/buildroot/SOURCES/xcp-sm-pylint-fix.patch" "${xenserver-buildroot}/usr/share/buildroot/SOURCES/xcp-sm-scsi-id-path.patch" ];

  buildInputs = [ pylint swig xen xapi python mock ];

  configurePhase = ''
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xcp-mpath-scsidev-rules xcp-mpath-scsidev-rules
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/xcp-mpath-scsidev-script xcp-mpath-scsidev-script

    sed -ie "s|@LIBDIR@|lib|g" drivers/SR.py
    sed -ie "s|@LIBDIR@|lib|g" drivers/blktap2.py
    sed -ie "s|@LIBDIR@|lib|g" drivers/vhdutil.py

    #TODO: Fix missing python packages, which are not passed in correctly from Xen.
    #HACK: Hack to overwrite errors detected by pylint.
    substituteInPlace Makefile --replace "exit 1" "true"
    '';

  buildPhase = ''
    DESTDIR=$out make
    '';

  installPhase = ''
    make PLUGIN_SCRIPT_DEST=lib/xapi/plugins/ SM_DEST=lib/xapi/sm/ DESTDIR=$out/ install
    mkdir -p $out/etc/udev/rules.d
    install -m 0644 xcp-mpath-scsidev-rules $out/etc/udev/rules.d/55-xs-mpath-scsidev.rules
    mkdir -p $out/etc/udev/scripts
    install -m 0755 xcp-mpath-scsidev-script $out/etc/udev/scripts/xs-mpath-scsidev.sh
    '';

  meta = {
    homepage = https://github.com/xapi-project/sm;
    description = "XCP storage managers";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
