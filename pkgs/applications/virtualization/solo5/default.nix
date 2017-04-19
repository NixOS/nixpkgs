{ stdenv, fetchFromGitHub }:
  stdenv.mkDerivation { 
    name = "solo5";
    hardeningDisable = [ "stackprotector" ];
    installPhase = ''
      PREFIX=$out
      BINDIR=$PREFIX/bin
      UKVM_LIBDIR=$PREFIX/ukvm/lib/
      UKVM_INCDIR=$PREFIX/ukvm/include
      VIRTIO_LIBDIR=$PREFIX/virtio/lib/
      VIRTIO_INCDIR=$PREFIX/virtio/include

      #virtio install
      mkdir -p $VIRTIO_INCDIR $VIRTIO_LIBDIR
      cp kernel/solo5.h $VIRTIO_INCDIR/solo5.h
      mkdir -p $VIRTIO_INCDIR/host
      cp -R include-host/. $VIRTIO_INCDIR/host
      cp kernel/virtio/solo5.o kernel/virtio/solo5.lds $VIRTIO_LIBDIR
      mkdir -p $BINDIR
      cp tools/mkimage/solo5-mkimage.sh $BINDIR/solo5-mkimage
      cp tools/run/solo5-run-virtio.sh $BINDIR/solo5-run-virtio

      #ukvm install
      mkdir -p $UKVM_INCDIR $UKVM_LIBDIR
      cp kernel/solo5.h $UKVM_INCDIR/solo5.h
      cp ukvm/ukvm.h $UKVM_INCDIR/ukvm.h
      mkdir -p $UKVM_INCDIR/host
      cp -R include-host/. $UKVM_INCDIR/host
      cp kernel/ukvm/solo5.o kernel/ukvm/solo5.lds $UKVM_LIBDIR
      mkdir -p $BINDIR
      mkdir -p $UKVM_LIBDIR/src
      cp -R ukvm $UKVM_LIBDIR/src
      cp ukvm/ukvm-configure $BINDIR
    '';
    src = fetchFromGitHub { 
      owner = "Solo5";
      repo = "solo5";
      rev = "93a7a311efeb04cd09911e1914e8078faa794801";
      sha256 = "049ydxnk32ag4id43k21l49dgdky6gaahydvsb1ms4f18n5g1axg";
    };
}
