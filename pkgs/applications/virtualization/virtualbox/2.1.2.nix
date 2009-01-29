{stdenv, fetchurl, iasl, dev86, libxslt, libxml2, libX11, xproto, libXext, libXcursor, qt3, qt4, libIDL, SDL, hal, libcap, zlib, libpng, glib, kernel}:

stdenv.mkDerivation {
  name = "virtualbox-2.1.2";

  src = fetchurl {
    url = http://download.virtualbox.org/virtualbox/2.1.2/VirtualBox-2.1.2-OSE.tar.bz2;
    sha256 = "d3c1ae8ed7594094aaf8496204c5415479e1943e5b5179c5baae8a66885362de";
  };

  buildInputs = [iasl dev86 libxslt libxml2 xproto libX11 libXext libXcursor qt3 qt4 libIDL SDL hal libcap glib kernel];

  patchPhase = "
    set -x
    MODULES_BUILD_DIR=`echo ${kernel}/lib/modules/*/build`
    sed -e 's@/lib/modules/`uname -r`/build@'$MODULES_BUILD_DIR@ \\
        -i configure
    ls kBuild/bin/linux.x86/k* tools/linux.x86/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 
    export USER=nix
    set +x
  ";

  configurePhase = ''
    # It wants the qt utils from qt3, and it takes them from QTDIR
    export QTDIR=${qt3}
    ./configure --with-qt-dir=${qt3} --with-qt4-dir=${qt4} --disable-python --disable-alsa --disable-pulse --disable-hardening
    sed -e 's@PKG_CONFIG_PATH=.*@PKG_CONFIG_PATH=${libIDL}/lib/pkgconfig:${glib}/lib/pkgconfig ${libIDL}/bin/libIDL-config-2@' \
        -i AutoConfig.kmk
    sed -e 's@arch/x86/@@' \
        -i Config.kmk
    cat >> AutoConfig.kmk << END_PATHS
    VBOX_PATH_APP_PRIVATE := $out
    VBOX_PATH_APP_DOCS := $out/doc
    END_PATHS
  '';

  buildPhase = "
    source env.sh
    kmk
  ";
    
  
  meta = {
    description = "PC emulator";
    homepage = http://www.virtualbox.org/;
  };
}
