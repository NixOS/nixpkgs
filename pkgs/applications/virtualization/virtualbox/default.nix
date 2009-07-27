{ stdenv, fetchurl, iasl, dev86, libxslt, libxml2, libX11, xproto, libXext
, libXcursor, qt3, qt4, libIDL, SDL, hal, libcap, zlib, libpng, glib, kernel
, python, which, alsaLib, curl
}:

stdenv.mkDerivation {
  name = "virtualbox-3.0.2-${kernel.version}";

  src = fetchurl {
    url = http://download.virtualbox.org/virtualbox/3.0.2/VirtualBox-3.0.2-OSE.tar.bz2;
    sha256 = "1s4zwfwskmj1arvvjx2qbvqg0bv6b39payqz63lfmbh3f720zvj1";
  };

  buildInputs = [iasl dev86 libxslt libxml2 xproto libX11 libXext libXcursor qt3 qt4 libIDL SDL hal libcap glib kernel python alsaLib curl];

  patchPhase = "
    set -x
    MODULES_BUILD_DIR=`echo ${kernel}/lib/modules/*/build`
    sed -e 's@/lib/modules/`uname -r`/build@'$MODULES_BUILD_DIR@ \\
        -i configure
    ls kBuild/bin/linux.x86/k* tools/linux.x86/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 
    ls kBuild/bin/linux.amd64/k* tools/linux.amd64/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 
    export USER=nix
    set +x
  ";

  configurePhase = ''
    # It wants the qt utils from qt3, and it takes them from QTDIR
    export QTDIR=${qt3}
    ./configure --with-qt-dir=${qt3} --with-qt4-dir=${qt4} --disable-python --disable-pulse --disable-hardening
    sed -e 's@PKG_CONFIG_PATH=.*@PKG_CONFIG_PATH=${libIDL}/lib/pkgconfig:${glib}/lib/pkgconfig ${libIDL}/bin/libIDL-config-2@' \
        -i AutoConfig.kmk
    sed -e 's@arch/x86/@@' \
        -i Config.kmk
    cat >> AutoConfig.kmk << END_PATHS
    VBOX_PATH_APP_PRIVATE := $out
    VBOX_PATH_APP_DOCS := $out/doc
    END_PATHS
  '';

  buildPhase = ''
    source env.sh
    kmk
    cd out/linux.*/release/bin/src
    export KERN_DIR=${kernel}/lib/modules/*/build
    make
    cd ../../../../..
  '';
    
  installPhase = ''
    cd out/linux.*/release/bin
    ensureDir $out/virtualbox
    cp -av * $out/virtualbox
    cd src
    kernelVersion=$(cd ${kernel}/lib/modules; ls)
    export MODULE_DIR=$out/lib/modules/$kernelVersion/misc
    ensureDir $MODULE_DIR    
    make install
    ensureDir $out/bin
    cp -v ${./VBox.sh} $out/bin/VBox.sh
    sed -i -e "s|@INSTALL_PATH@|$out/virtualbox|" \
           -e "s|@QT4_PATH@|${qt4}/lib|" \
	   -e "s|which|${which}/bin/which|" \
	   -e "s|awk|${stdenv.gawk}/bin/awk|" \
	   $out/bin/VBox.sh
    chmod 755 $out/bin/VBox.sh
    for file in VirtualBox VBoxManage VBoxSDL
    do
        [ -f "$out/virtualbox/$file" ] && ln -sfv $out/bin/VBox.sh $out/bin/$file
    done
    ensureDir $out/share/applications
    ln -sfv $out/virtualbox/VirtualBox.desktop $out/share/applications
  '';
  
  meta = {
    description = "PC emulator";
    homepage = http://www.virtualbox.org/;
  };
}
