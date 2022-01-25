{ stdenv, lib, fetchurl, callPackage, patchelf, makeWrapper, coreutils, libusb1, avahi-compat, glib, libredirect, nixosTests }:
let
  myPatchElf = file: with lib; ''
    patchelf --set-interpreter \
      ${stdenv.glibc}/lib/ld-linux${optionalString stdenv.is64bit "-x86-64"}.so.2 \
      ${file}
  '';

in
stdenv.mkDerivation rec {
  pname = "brscan5";
  version = "1.2.7-0";
  src = {
    "i686-linux" = fetchurl {
      url = "https://download.brother.com/welcome/dlf104034/${pname}-${version}.i386.deb";
      sha256 = "647d06f629c22408d25be7c0bf49a4b1c7280bf78a27aa2cde6c3e3fa8b6807a";
    };
    "x86_64-linux" = fetchurl {
      url = "https://download.brother.com/welcome/dlf104033/${pname}-${version}.amd64.deb";
      sha256 = "867bd88ab0d90f8e9391dc8127385095127e533cb6bd2d5d13449df602b165ae";
    };
  }."${stdenv.hostPlatform.system}";

  unpackPhase = ''
    ar x $src
    tar xfv data.tar.xz
  '';

  nativeBuildInputs = [ makeWrapper patchelf coreutils ];
  buildInputs = [ libusb1 avahi-compat stdenv.cc.cc glib ];
  dontBuild = true;

  postPatch = ''
    ${myPatchElf "opt/brother/scanner/brscan5/brsaneconfig5"}
    ${myPatchElf "opt/brother/scanner/brscan5/brscan_cnetconfig"}
    ${myPatchElf "opt/brother/scanner/brscan5/brscan_gnetconfig"}

    for a in opt/brother/scanner/brscan5/*.so.* opt/brother/scanner/brscan5/brscan_[cg]netconfig; do
      if ! test -L $a; then
        patchelf --set-rpath ${lib.makeLibraryPath buildInputs} $a
      fi
    done

    # driver is hardcoded to look in /opt/brother/scanner/brscan5/models for model metadata.
    # patch it to look in /etc/opt/brother/scanner/models instead, so nixos environment.etc can make it available
    printf '/etc/opt/brother/scanner/models\x00' | dd of=opt/brother/scanner/brscan5/libsane-brother5.so.1.0.7 bs=1 seek=84632 conv=notrunc
  '';

  installPhase = with lib; ''
    runHook preInstall
    PATH_TO_BRSCAN5="opt/brother/scanner/brscan5"
    mkdir -p $out/$PATH_TO_BRSCAN5
    cp -rp $PATH_TO_BRSCAN5/* $out/$PATH_TO_BRSCAN5


    pushd $out/$PATH_TO_BRSCAN5
      ln -s libLxBsDeviceAccs.so.1.0.0 libLxBsDeviceAccs.so.1
      ln -s libLxBsNetDevAccs.so.1.0.0 libLxBsNetDevAccs.so.1
      ln -s libLxBsScanCoreApi.so.3.2.0 libLxBsScanCoreApi.so.3
      ln -s libLxBsUsbDevAccs.so.1.0.0 libLxBsUsbDevAccs.so.1
      ln -s libsane-brother5.so.1.0.7 libsane-brother5.so.1
    popd

    mkdir -p $out/lib/sane
    for file in $out/$PATH_TO_BRSCAN5/*.so.* ; do
      ln -s $file $out/lib/sane/
    done

    makeWrapper \
      "$out/$PATH_TO_BRSCAN5/brsaneconfig5" \
      "$out/bin/brsaneconfig5" \
      --suffix-each NIX_REDIRECT ":" "/etc/opt/brother/scanner/brscan5=$out/opt/brother/scanner/brscan5 /opt/brother/scanner/brscan5=$out/opt/brother/scanner/brscan5" \
      --set LD_PRELOAD ${libredirect}/lib/libredirect.so

    mkdir -p $out/etc/sane.d/dll.d
    echo "brother5" > $out/etc/sane.d/dll.d/brother5.conf

    mkdir -p $out/etc/udev/rules.d
    cp -p $PATH_TO_BRSCAN5/udev-rules/NN-brother-mfp-brscan5-1.0.2-2.rules \
      $out/etc/udev/rules.d/49-brother-mfp-brscan5-1.0.2-2.rules

    ETCDIR=$out/etc/opt/brother/scanner/brscan5
    mkdir -p $ETCDIR
    cp -rp $PATH_TO_BRSCAN5/{models,brscan5.ini,brsanenetdevice.cfg} $ETCDIR/

    runHook postInstall
  '';

  dontPatchELF = true;

  passthru.tests = { inherit (nixosTests) brscan5; };

  meta = {
    description = "Brother brscan5 sane backend driver";
    homepage = "https://www.brother.com";
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ mattchrist ];
  };
}
