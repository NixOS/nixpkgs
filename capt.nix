{
  stdenv,
  automake, autoconf, libtool, pkgconfig,
  cups, glib, gnome2, atk, libxml2, popt, ghostscript,
  cndrvcups-common
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "cndrvcups-capt";
  version = "2.71";

  src = ./cndrvcups-capt-2.71;

  #TODO: prune unused dependencies
  buildInputs = [
    automake autoconf libtool pkgconfig
    cups
    glib
    gnome2.libglade
    gnome2.gtk
    atk
    libxml2.dev
    popt
    ghostscript
    cndrvcups-common
  ];

  # install directions based on arch PKGBUILD file
  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=capt-src

  configurePhase = ''
    set -xe

    for _dir in driver ppd backend pstocapt pstocapt2 pstocapt3
    do
        pushd $_dir
          autoreconf -fi
          LDFLAGS=-L${cndrvcups-common}/usr/lib \
            CPPFLAGS=-I${cndrvcups-common}/usr/include \
            ./autogen.sh --prefix=$out/usr \
            --enable-progpath=$out/usr/bin --disable-static
        popd
    done

    pushd statusui
      autoreconf -fi
      LDFLAGS=-L${cndrvcups-common}/usr/lib \
        LIBS='-lpthread -lgdk-x11-2.0 -lgobject-2.0 -lglib-2.0 -latk-1.0 -lgdk_pixbuf-2.0' \
        CPPFLAGS="-I${cndrvcups-common}/usr/include -I${libxml2.dev}/include/libxml2" \
        ./autogen.sh --prefix=$out/usr --disable-static
    popd

    pushd cngplp
      LDFLAGS=-L${cndrvcups-common}/usr/lib autoreconf -fi
      LDFLAGS=-L${cndrvcups-common}/usr/lib \
        CPPFLAGS=-I${cndrvcups-common}/usr/include \
        ./autogen.sh --prefix=$out/usr --libdir=$out/usr/lib
    popd

    pushd cngplp/files
      LDFLAGS=-L${cndrvcups-common}/usr/lib autoreconf -fi
      LDFLAGS=-L${cndrvcups-common}/usr/lib \
        CPPFLAGS=-I${cndrvcups-common}/usr/include ./autogen.sh
    popd
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out
    # for _dir in driver ppd backend pstocapt pstocapt2 pstocapt3 statusui cngplp
    # do
    #     pushd $_dir
    #       make install DESTDIR=$out
    #     popd
    # done
    #
    # install -dm755 $out/lib
    # install -c libs/libcaptfilter.so.1.0.0  $out/lib
    # install -c libs/libcaiocaptnet.so.1.0.0 $out/lib
    # install -c libs/libcncaptnpm.so.2.0.1   $out/lib
    # install -c -m 755 libs/libcnaccm.so.1.0 $out/lib
    #
    # pushd $out/lib
    #   ln -s libcaptfilter.so.1.0.0 libcaptfilter.so.1
    #   ln -s libcaptfilter.so.1.0.0 libcaptfilter.so
    #   ln -s libcaiocaptnet.so.1.0.0 libcaiocaptnet.so.1
    #   ln -s libcaiocaptnet.so.1.0.0 libcaiocaptnet.so
    #   ln -s libcncaptnpm.so.2.0.1 libcncaptnpm.so.2
    #   ln -s libcncaptnpm.so.2.0.1 libcncaptnpm.so
    #   ln -s libcnaccm.so.1.0 libcnaccm.so.1
    #   ln -s libcnaccm.so.1.0 libcnaccm.so
    # popd
    #
    # install -dm755 $out/usr/bin
    #
    # install -c libs/captdrv            $out/usr/bin
    # install -c libs/captfilter         $out/usr/bin
    # install -c libs/captmon/captmon    $out/usr/bin
    # install -c libs/captmon2/captmon2  $out/usr/bin
    # install -c libs/captemon/captmon*  $out/usr/bin
    #
    # ##FIXME: currently install x64 only, find the way to choose
    # install -c libs64/ccpd       $out/usr/bin
    # install -c libs64/ccpdadmin  $out/usr/bin
    # # install -c libs/ccpd       $out/usr/bin
    # # install -c libs/ccpdadmin  $out/usr/bin
    #
    # install -dm755 $out/etc
    # install -c samples/ccpd.conf  $out/etc
    #
    # install -dm755 $out/usr/share/ccpd
    # install -c libs/ccpddata/CNA*L.BIN    $out/usr/share/ccpd
    # install -c libs/ccpddata/CNA*LS.BIN   $out/usr/share/ccpd
    # install -c libs/ccpddata/cnab6cl.bin  $out/usr/share/ccpd
    # install -c libs/captemon/CNAC*.BIN    $out/usr/share/ccpd
    #
    # install -dm755 $out/usr/share/captfilter
    # install -c libs/CnA*INK.DAT $out/usr/share/captfilter
    #
    # install -dm755 $out/usr/share/captmon
    # install -c libs/captmon/msgtable.xml    $out/usr/share/captmon
    # install -dm755 $out/usr/share/captmon2
    # install -c libs/captmon2/msgtable2.xml  $out/usr/share/captmon2
    # install -dm755 $out/usr/share/captemon
    # install -c libs/captemon/msgtablelbp*   $out/usr/share/captemon
    # install -c libs/captemon/msgtablecn*    $out/usr/share/captemon
    # install -dm755 $out/usr/share/caepcm
    # install -c -m 644 data/C*   $out/usr/share/caepcm
    # install -dm755 $out/usr/share/doc/capt-src
    # install -c -m 644 *capt*.txt $out/usr/share/doc/capt-src
  '';

  meta = with stdenv.lib; {
    description = "Canon CAPT driver";
    longDescription = ''
      Canon CAPT driver
    '';
  };
}
