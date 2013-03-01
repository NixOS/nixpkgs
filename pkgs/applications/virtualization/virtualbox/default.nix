{ stdenv, fetchurl, lib, iasl, dev86, pam, libxslt, libxml2, libX11, xproto, libXext
, libXcursor, libXmu, qt4, libIDL, SDL, libcap, zlib, libpng, glib, kernel, lvm2
, which, alsaLib, curl, gawk
, xorriso, makeself, perl, pkgconfig
, javaBindings ? false, jdk ? null
, pythonBindings ? false, python ? null
, enableExtensionPack ? false, requireFile ? null, patchelf ? null
}:

with stdenv.lib;

let

  version = "4.2.8";
  extpackRevision = "83876";

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

  extensionPack = requireFile {
    name = "Oracle_VM_VirtualBox_Extension_Pack-${version}-${extpackRevision}"
         + ".vbox-extpack";
    # Has to be base16 because it's used as an input to VBoxExtPackHelperApp!
    sha256 = "fa579416f382b58c4e93d3740d076ceba728e28d987e51aced5865a46cb9111c";
    url = "https://www.virtualbox.org/wiki/Downloads";
  };

in stdenv.mkDerivation {
  name = "virtualbox-${version}-${kernel.version}";

  src = fetchurl {
    url = "http://download.virtualbox.org/virtualbox/${version}/VirtualBox-${version}.tar.bz2";
    sha256 = "bc9185e0c300d61e2a6c8ac48b4bea6a0a456c9ba11d1fbadf2d1e6ca063f2b4";
  };

  buildInputs =
    [ iasl dev86 libxslt libxml2 xproto libX11 libXext libXcursor qt4 libIDL SDL
      libcap glib kernel lvm2 python alsaLib curl pam xorriso makeself perl
      pkgconfig which libXmu ]
    ++ optional javaBindings jdk
    ++ optional pythonBindings python;

  patches = singleton ./missing_files_4.2.8.patch;

  prePatch = ''
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

    ${optionalString enableExtensionPack ''
      "$libexec/VBoxExtPackHelperApp" install \
        --base-dir "$libexec/ExtensionPacks" \
        --cert-dir "$libexec/ExtPackCertificates" \
        --name "Oracle VM VirtualBox Extension Pack" \
        --tarball "${extensionPack}" \
        --sha-256 "${extensionPack.outputHash}"
    ''}

    # Create and fix desktop item
    mkdir -p $out/share/applications
    sed -i -e "s|Icon=VBox|Icon=$libexec/VBox.png|" $libexec/virtualbox.desktop
    ln -sfv $libexec/virtualbox.desktop $out/share/applications
    # Icons
    mkdir -p $out/share/icons/hicolor
    for size in `ls -1 $libexec/icons`; do
      mkdir -p $out/share/icons/hicolor/$size/apps
      ln -s $libexec/icons/$size/*.png $out/share/icons/hicolor/$size/apps
    done
  '';

  meta = {
    description = "PC emulator";
    homepage = http://www.virtualbox.org/;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.linux;
  };
}
