{ config, stdenv, kernel, fetchurl, lib, pam, libxslt
, libX11, libXext, libXcursor, libXmu
, glib, libXrandr, dbus, xz
, pkg-config, which, zlib, xorg
, yasm, patchelf, makeself
, linuxHeaders, openssl}:

let
  buildType = "release";

in stdenv.mkDerivation (finalAttrs: {
  pname = "VirtualBox-GuestAdditions-builder-${kernel.version}";
  version = "7.0.18";

  src = fetchurl {
    url = "https://download.virtualbox.org/virtualbox/${finalAttrs.version}/VirtualBox-${finalAttrs.version}.tar.bz2";
    sha256 = "d999513533631674a024762668de999411d8197060c51e68c5faf0a2c0eea1a5";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types -Wno-error=implicit-function-declaration";

  nativeBuildInputs = [ patchelf pkg-config which yasm makeself xorg.xorgserver openssl linuxHeaders xz ] ++ kernel.moduleBuildDependencies;
  buildInputs = [ dbus libxslt libXext libXcursor pam libXmu libXrandr ];

  KERN_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  KERN_INCL = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/source/include";

  prePatch = ''
    rm -r src/VBox/Additions/x11/x11include/
    rm -r src/VBox/Additions/3D/mesa/mesa-*/
    rm -r src/libs/openssl-*/
    rm -r src/libs/curl-*/
    rm -r src/libs/libpng-*/
    rm -r src/libs/libxml2-*/
    rm -r src/libs/liblzma-*/
    rm -r src/libs/zlib*/
  '';

  patches = [
    #../gcc-13.patch
    ## https://www.virtualbox.org/changeset/100258/vbox
    ./no-legacy-xorg.patch
  ];

  postPatch = ''
    set -x
    sed -e 's@MKISOFS --version@MKISOFS -version@' \
        -e 's@CXX_FLAGS="\(.*\)"@CXX_FLAGS="-std=c++17 \1"@' \
        -i configure
    ls kBuild/bin/linux.x86/k* tools/linux.x86/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2
    ls kBuild/bin/linux.amd64/k* tools/linux.amd64/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2

    substituteInPlace ./include/VBox/dbus-calls.h --replace-fail libdbus-1.so.3 ${dbus.lib}/lib/libdbus-1.so.3

    substituteInPlace ./src/VBox/Additions/common/VBoxGuest/lib/VBoxGuestR3LibDrmClient.cpp --replace-fail /usr/bin/VBoxDRMClient /run/current-system/sw/bin/VBoxDRMClient
    substituteInPlace ./src/VBox/Additions/common/VBoxGuest/lib/VBoxGuestR3LibDrmClient.cpp --replace-fail /usr/bin/VBoxClient /run/current-system/sw/bin/VBoxClient
    substituteInPlace ./src/VBox/Additions/x11/VBoxClient/display.cpp --replace-fail /usr/X11/bin/xrandr ${xorg.xrandr}/bin/xrandr
    substituteInPlace ./src/VBox/Additions/x11/vboxvideo/Makefile.kmk --replace-fail /usr/include/xorg "${xorg.xorgserver.dev}/include/xorg "
  '';

  configurePhase = ''
      NIX_CFLAGS_COMPILE=$(echo "$NIX_CFLAGS_COMPILE" | sed 's,\-isystem ${lib.getDev stdenv.cc.libc}/include,,g')

      cat >> LocalConfig.kmk <<LOCAL_CONFIG
      VBOX_WITH_TESTCASES            :=
      VBOX_WITH_TESTSUITE            :=
      VBOX_WITH_VALIDATIONKIT        :=
      VBOX_WITH_DOCS                 :=
      VBOX_WITH_WARNINGS_AS_ERRORS   :=

      VBOX_WITH_ORIGIN               :=
      VBOX_PATH_APP_PRIVATE_ARCH_TOP := $out/share/virtualbox
      VBOX_PATH_APP_PRIVATE_ARCH     := $out/libexec/virtualbox
      VBOX_PATH_SHARED_LIBS          := $out/libexec/virtualbox
      VBOX_WITH_RUNPATH              := $out/libexec/virtualbox
      VBOX_PATH_APP_PRIVATE          := $out/share/virtualbox
      VBOX_PATH_APP_DOCS             := $out/doc

      VBOX_USE_SYSTEM_XORG_HEADERS := 1
      VBOX_USE_SYSTEM_GL_HEADERS := 1
      VBOX_NO_LEGACY_XORG_X11 := 1
      SDK_VBoxLibPng_INCS :=
      SDK_VBoxLibXml2_INCS :=
      SDK_VBoxLibLzma_INCS := ${xz.dev}/include
      SDK_VBoxLibLzma_LIBS := ${xz.out}/lib

      SDK_VBoxOpenSslStatic_INCS := ${openssl.dev}/include/ssl

      VBOX_ONLY_ADDITIONS := 1
      VBOX_WITH_SHARED_CLIPBOARD := 1
      VBOX_WITH_GUEST_PROPS := 1
      VBOX_WITH_VMSVGA := 1
      VBOX_WITH_SHARED_FOLDERS := 1
      VBOX_WITH_GUEST_CONTROL := 1
      VBOX_WITHOUT_LINUX_GUEST_PACKAGE := 1
      VBOX_WITH_PAM :=
      VBOX_WITH_UPDATE_AGENT :=
      VBOX_WITH_AUDIO_ALSA :=
      VBOX_WITH_AUDIO_PULSE :=

      VBOX_BUILD_PUBLISHER := _NixOS
      LOCAL_CONFIG

      ./configure \
        --only-additions \
        --with-linux=${kernel.dev} \
        --disable-kmods

      sed -e 's@PKG_CONFIG_PATH=.*@PKG_CONFIG_PATH=${glib.dev}/lib/pkgconfig @' \
        -i AutoConfig.kmk
      sed -e 's@arch/x86/@@' \
        -i Config.kmk

      export USER=nix
      set +x
    '';

  enableParallelBuilding = true;

  buildPhase = ''
    runHook preBuild

    source env.sh
    VBOX_ONLY_ADDITIONS=1 VBOX_ONLY_BUILD=1 kmk -j $NIX_BUILD_CORES BUILD_TYPE="${buildType}"
    VBOX_ONLY_ADDITIONS=1 VBOX_ONLY_BUILD=1 kmk packing

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -rv ./out/linux.${if stdenv.hostPlatform.is32bit then "x86" else "amd64"}/${buildType}/bin/additions/VBoxGuestAdditions-${if stdenv.hostPlatform.is32bit then "x86" else "amd64"}.tar.bz2 $out/

    runHook postInstall
  '';
})
