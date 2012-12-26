{ stdenv, fetchurl, lib, iasl, dev86, pam, libxslt, libxml2, libX11, xproto, libXext
, libXcursor, libXmu, qt4, libIDL, SDL, libcap, zlib, libpng, glib, kernel
, which, alsaLib, curl, gawk
, xorriso, makeself, perl, pkgconfig
, javaBindings ? false, jdk ? null
, pythonBindings ? false, python ? null
}:

with stdenv.lib;

let

  version = "4.1.22";

  forEachModule = action: ''
    for mod in \
      $sourcedir/out/linux.*/release/bin/src/vboxdrv \
      $sourcedir/out/linux.*/release/bin/src/vboxpci \
      $sourcedir/out/linux.*/release/bin/src/vboxnetadp \
      $sourcedir/out/linux.*/release/bin/src/vboxnetflt
    do
      if [ "x$(basename "$mod")" != xvboxdrv -a ! -e "$mod/Module.symvers" ]
      then
        cp -v $sourcedir/out/linux.*/release/bin/src/vboxdrv/Module.symvers \
              "$mod/Module.symvers"
      fi
      INSTALL_MOD_PATH="$out" INSTALL_MOD_DIR=misc \
      make -C "$MODULES_BUILD_DIR" "M=$mod" DEPMOD=/do_not_use_depmod ${action}
    done
  '';

in stdenv.mkDerivation {
  name = "virtualbox-${version}-${kernel.version}";

  src = fetchurl {
    url = "http://download.virtualbox.org/virtualbox/${version}/VirtualBox-${version}.tar.bz2";
    sha256 = "7abb506203dd0d69b4b408fd999b5b9a479a9adce5f80e9b5569641c053dd153";
  };

  buildInputs =
    [ iasl dev86 libxslt libxml2 xproto libX11 libXext libXcursor qt4 libIDL SDL
      libcap glib kernel python alsaLib curl pam xorriso makeself perl
      pkgconfig which libXmu ]
    ++ optional javaBindings jdk
    ++ optional pythonBindings python;

  patchPhase = ''
    set -x
    MODULES_BUILD_DIR=`echo ${kernel}/lib/modules/*/build`
    sed -e 's@/lib/modules/`uname -r`/build@'$MODULES_BUILD_DIR@ \
        -e 's@MKISOFS --version@MKISOFS -version@' \
        -e 's@PYTHONDIR=.*@PYTHONDIR=${if pythonBindings then python else ""}@' \
        -i configure
    ls kBuild/bin/linux.x86/k* tools/linux.x86/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2
    ls kBuild/bin/linux.amd64/k* tools/linux.amd64/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2
    find . -type f | xargs sed 's/depmod -a/true/' -i
    export USER=nix
    set +x
  '';

  configurePhase = ''
    sourcedir="$(pwd)"
    ./configure --with-qt4-dir=${qt4} \
      ${optionalString (!javaBindings) "--disable-java"} \
      ${optionalString (!pythonBindings) "--disable-python"} \
      --disable-pulse --disable-hardening --disable-kmods \
      --with-mkisofs=${xorriso}/bin/xorrisofs
    sed -e 's@PKG_CONFIG_PATH=.*@PKG_CONFIG_PATH=${libIDL}/lib/pkgconfig:${glib}/lib/pkgconfig ${libIDL}/bin/libIDL-config-2@' \
        -i AutoConfig.kmk
    sed -e 's@arch/x86/@@' \
        -i Config.kmk
    substituteInPlace Config.kmk --replace "VBOX_WITH_TESTCASES = 1" "#"
    cat >> AutoConfig.kmk << END_PATHS
    VBOX_PATH_APP_PRIVATE := $out
    VBOX_PATH_APP_DOCS := $out/doc
    ${optionalString javaBindings ''
      VBOX_JAVA_HOME := ${jdk}
    ''}
    END_PATHS
    echo "VBOX_WITH_DOCS :=" >> LocalConfig.kmk
    echo "VBOX_WITH_WARNINGS_AS_ERRORS :=" >> LocalConfig.kmk
  '';

  enableParallelBuilding = true;

  buildPhase = ''
    source env.sh
    kmk
    ${forEachModule "modules"}
  '';

  installPhase = ''
    libexec=$out/libexec/virtualbox

    # Install VirtualBox files
    cd out/linux.*/release/bin
    mkdir -p $libexec
    cp -av * $libexec

    # Install kernel modules
    ${forEachModule "modules_install"}

    # Create wrapper script
    mkdir -p $out/bin
    for file in VirtualBox VBoxManage VBoxSDL VBoxBalloonCtrl VBoxBFE VBoxHeadless; do
        ln -s "$libexec/$file" $out/bin/$file
    done

    # Create and fix desktop item
    mkdir -p $out/share/applications
    sed -i -e "s|Icon=VBox|Icon=$libexec/VBox.png|" $libexec/virtualbox.desktop
    ln -sfv $libexec/virtualbox.desktop $out/share/applications
  '';

  meta = {
    description = "PC emulator";
    homepage = http://www.virtualbox.org/;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.linux;
  };
}
