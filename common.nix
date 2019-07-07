{
  stdenv,
  automake, autoconf, libtool, pkgconfig,
  cups, glib, gnome2, atk, libxml2, popt, ghostscript
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "cndrvcups-common";
  version = "3.21";

  src = ./cndrvcups-common-3.21;

  #TODO: prune unused dependencies
  buildInputs = [
    automake autoconf libtool pkgconfig
    cups
    glib
    gnome2.libglade
    gnome2.gtk
    atk
    libxml2
    popt
    ghostscript
  ];

  # install directions based on arch PKGBUILD file
  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=capt-src

  configurePhase = ''
    pushd buftool
      autoreconf -fi
      ./autogen.sh --prefix=$out --libdir=$out/lib
    popd

    pushd cngplp
      autoreconf -fi
      LIBS='-lgmodule-2.0 -lgtk-x11-2.0 -lglib-2.0 -lgobject-2.0'\
        ./autogen.sh --prefix=$out --libdir=$out/lib
    popd

    pushd backend
      autoreconf -fi
      ./autogen.sh --prefix=$out --libdir=$out/lib
    popd
  '';

  buildPhase = ''
    make

    pushd c3plmod_ipc
      make
    popd
  '';

  installPhase = ''
    mkdir -p $out
    for _dir in buftool cngplp backend
    do
        pushd $_dir
          DESTDIR=$out make install
        popd
    done

    pushd c3plmod_ipc
      DESTDIR=$out LIBDIR=$out/lib make install
    popd

    ##HACK: `make install` install files to wrong directory
    cp -rv $out/$out/* $out
    rm -r $out/nix

    install -dm755 $out/bin
    install -c -m 755 libs/c3pldrv $out/bin
    install -dm755 $out/lib
    install -c -m 755 libs/libcaiowrap.so.1.0.0   $out/lib
    install -c -m 755 libs/libcaiousb.so.1.0.0    $out/lib
    install -c -m 755 libs/libc3pl.so.0.0.1       $out/lib
    install -c -m 755 libs/libcaepcm.so.1.0       $out/lib
    install -c -m 755 libs/libColorGear.so.0.0.0  $out/lib
    install -c -m 755 libs/libColorGearC.so.0.0.0 $out/lib
    install -c -m 755 libs/libcanon_slim.so.1.0.0 $out/lib

    pushd $out/lib
      ln -s libc3pl.so.0.0.1 libc3pl.so.0
      ln -s libc3pl.so.0.0.1 libc3pl.so
      ln -s libcaepcm.so.1.0 libcaepcm.so.1
      ln -s libcaepcm.so.1.0 libcaepcm.so
      ln -s libcaiowrap.so.1.0.0 libcaiowrap.so.1
      ln -s libcaiowrap.so.1.0.0 libcaiowrap.so
      ln -s libcaiousb.so.1.0.0 libcaiousb.so.1
      ln -s libcaiousb.so.1.0.0 libcaiousb.so
      ln -s libcanonc3pl.so.1.0.0 libcanonc3pl.so.1
      ln -s libcanonc3pl.so.1.0.0 libcanonc3pl.so
      ln -s libcanon_slim.so.1.0.0 libcanon_slim.so.1
      ln -s libcanon_slim.so.1.0.0 libcanon_slim.so
      ln -s libColorGear.so.0.0.0 libColorGear.so.0
      ln -s libColorGear.so.0.0.0 libColorGear.so
      ln -s libColorGearC.so.0.0.0 libColorGearC.so.0
      ln -s libColorGearC.so.0.0.0 libColorGearC.so
    popd

    install -dm755 $out/share/caepcm
    install -c -m 644 data/*.ICC  $out/share/caepcm
  '';

  meta = with stdenv.lib; {
    description = "Canon CAPT driver";
    longDescription = ''
      Canon CAPT driver
    '';
  };
}
