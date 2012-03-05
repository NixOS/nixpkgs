{ stdenv, fetchurl, lib, iasl, dev86, pam, libxslt, libxml2, libX11, xproto, libXext
, libXcursor, libXmu, qt4, libIDL, SDL, libcap, zlib, libpng, glib, kernel
, python, which, alsaLib, curl, gawk
, xorriso, makeself, perl, jdk, pkgconfig
}:

let version = "4.1.8"; in

stdenv.mkDerivation {
  name = "virtualbox-${version}-${kernel.version}";

  src = fetchurl {
    url = "http://download.virtualbox.org/virtualbox/${version}/VirtualBox-${version}.tar.bz2";
    sha256 = "1q04825ayynzgh8zl6y038lzxp3jk1a3dxpg6f52kk4vkirdc5pg";
  };

  buildInputs =
    [ iasl dev86 libxslt libxml2 xproto libX11 libXext libXcursor qt4 libIDL SDL
      libcap glib kernel python alsaLib curl pam xorriso makeself perl jdk
      pkgconfig which libXmu
    ];

  patchPhase = ''
    set -x
    MODULES_BUILD_DIR=`echo ${kernel}/lib/modules/*/build`
    sed -e 's@/lib/modules/`uname -r`/build@'$MODULES_BUILD_DIR@ \
        -e 's@MKISOFS --version@MKISOFS -version@' \
        -i configure
    ls kBuild/bin/linux.x86/k* tools/linux.x86/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 
    ls kBuild/bin/linux.amd64/k* tools/linux.amd64/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 
    find . -type f | xargs sed 's/depmod -a/true/' -i
    export USER=nix
    set +x
  '';

  configurePhase = ''
    ./configure --with-qt4-dir=${qt4} --disable-python --disable-pulse --disable-hardening --with-mkisofs=${xorriso}/bin/xorrisofs
    sed -e 's@PKG_CONFIG_PATH=.*@PKG_CONFIG_PATH=${libIDL}/lib/pkgconfig:${glib}/lib/pkgconfig ${libIDL}/bin/libIDL-config-2@' \
        -i AutoConfig.kmk
    sed -e 's@arch/x86/@@' \
        -i Config.kmk
    substituteInPlace Config.kmk --replace "VBOX_WITH_TESTCASES = 1" "#"
    cat >> AutoConfig.kmk << END_PATHS
    VBOX_PATH_APP_PRIVATE := $out
    VBOX_PATH_APP_DOCS := $out/doc
    VBOX_JAVA_HOME := ${jdk}
    END_PATHS
    echo "VBOX_WITH_DOCS :=" >> LocalConfig.kmk
    echo "VBOX_WITH_WARNINGS_AS_ERRORS :=" >> LocalConfig.kmk
  '';

  enableParallelBuilding = true;

  preBuild = ''
    source env.sh
    kmk
    cd out/linux.*/release/bin/src
    export KERN_DIR=${kernel}/lib/modules/*/build
  '';

  postBuild = ''
    cd ../../../../..
  '';
    
  installPhase = ''
    # Install VirtualBox files
    cd out/linux.*/release/bin
    mkdir -p $out/virtualbox
    cp -av * $out/virtualbox
    
    # Install kernel module
    cd src
    kernelVersion=$(cd ${kernel}/lib/modules; ls)
    export MODULE_DIR=$out/lib/modules/$kernelVersion/misc
    
    # Remove root ownership stuff, since this does not work in a chroot environment
    for i in `find . -name Makefile`
    do
	sed -i -e "s|-o root||g" \
               -e "s|-g root||g" $i
    done
    
    # Install kernel modules
    make install
    
    # Create wrapper script
    mkdir -p $out/bin
    cp -v ${./VBox.sh} $out/bin/VBox.sh
    sed -i -e "s|@INSTALL_PATH@|$out/virtualbox|" \
           -e "s|@QT4_PATH@|${qt4}/lib|" \
	   -e "s|which|${which}/bin/which|" \
	   -e "s|awk|${gawk}/bin/awk|" \
	   $out/bin/VBox.sh
    chmod 755 $out/bin/VBox.sh
    for file in VirtualBox VBoxManage VBoxSDL
    do
        [ -f "$out/virtualbox/$file" ] && ln -sfv $out/bin/VBox.sh $out/bin/$file
    done
    
    # Create and fix desktop item
    mkdir -p $out/share/applications
    sed -i -e "s|Icon=VBox|Icon=$out/virtualbox/VBox.png|" $out/virtualbox/virtualbox.desktop
    ln -sfv $out/virtualbox/virtualbox.desktop $out/share/applications
  '';
  
  meta = {
    description = "PC emulator";
    homepage = http://www.virtualbox.org/;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.linux;
  };
}
