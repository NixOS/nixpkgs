{ config, stdenv, fetchurl, lib, acpica-tools, dev86, pam, libxslt, libxml2, wrapQtAppsHook
, libX11, xorgproto, libXext, libXcursor, libXmu, libIDL, SDL2, libcap, libGL, libGLU
, libpng, glib, lvm2, libXrandr, libXinerama, libopus, qtbase, qtx11extras
, qttools, qtsvg, qtwayland, pkg-config, which, docbook_xsl, docbook_xml_dtd_43
, alsa-lib, curl, libvpx, nettools, dbus, substituteAll, gsoap, zlib
, yasm, glslang
, linuxPackages
# If open-watcom-bin is not passed, VirtualBox will fall back to use
# the shipped alternative sources (assembly).
, open-watcom-bin
, makeself, perl
, javaBindings ? true, jdk # Almost doesn't affect closure size
, pythonBindings ? false, python3
, extensionPack ? null, fakeroot
, pulseSupport ? config.pulseaudio or stdenv.isLinux, libpulseaudio
, enableHardening ? false
, headless ? false
, enable32bitGuests ? true
, enableWebService ? false
}:

with lib;

let
  buildType = "release";
  # Use maintainers/scripts/update.nix to update the version and all related hashes or
  # change the hashes in extpack.nix and guest-additions/default.nix as well manually.
  version = "7.0.12";
in stdenv.mkDerivation {
  pname = "virtualbox";
  inherit version;

  src = fetchurl {
    url = "https://download.virtualbox.org/virtualbox/${version}/VirtualBox-${version}.tar.bz2";
    sha256 = "d76634c6ccf62503726a5aeae6c78a3462474c51a0ebe4942591ccc2d939890a";
  };

  outputs = [ "out" "modsrc" ];

  nativeBuildInputs = [ pkg-config which docbook_xsl docbook_xml_dtd_43 yasm glslang ]
    ++ optional (!headless) wrapQtAppsHook;

  # Wrap manually because we wrap just a small number of executables.
  dontWrapQtApps = true;

  buildInputs = [
    acpica-tools dev86 libxslt libxml2 xorgproto libX11 libXext libXcursor libIDL
    libcap glib lvm2 alsa-lib curl libvpx pam makeself perl
    libXmu libXrandr libpng libopus python3 ]
    ++ optional javaBindings jdk
    ++ optional pythonBindings python3 # Python is needed even when not building bindings
    ++ optional pulseSupport libpulseaudio
    ++ optionals headless [ libGL ]
    ++ optionals (!headless) [ qtbase qtx11extras libXinerama SDL2 libGLU ]
    ++ optionals enableWebService [ gsoap zlib ];

  hardeningDisable = [ "format" "fortify" "pic" "stackprotector" ];

  prePatch = ''
    set -x
    sed -e 's@MKISOFS --version@MKISOFS -version@' \
        -e 's@PYTHONDIR=.*@PYTHONDIR=${lib.optionalString pythonBindings python3}@' \
        -e 's@CXX_FLAGS="\(.*\)"@CXX_FLAGS="-std=c++11 \1"@' \
        ${optionalString (!headless) ''
        -e 's@TOOLQT5BIN=.*@TOOLQT5BIN="${getDev qtbase}/bin"@' \
        ''} -i configure
    ls kBuild/bin/linux.x86/k* tools/linux.x86/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2
    ls kBuild/bin/linux.amd64/k* tools/linux.amd64/bin/* | xargs -n 1 patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2

    grep 'libpulse\.so\.0'      src include -rI --files-with-match | xargs sed -i -e '
      ${optionalString pulseSupport
        ''s@"libpulse\.so\.0"@"${libpulseaudio.out}/lib/libpulse.so.0"@g''}'

    grep 'libdbus-1\.so\.3'     src include -rI --files-with-match | xargs sed -i -e '
      s@"libdbus-1\.so\.3"@"${dbus.lib}/lib/libdbus-1.so.3"@g'

    grep 'libasound\.so\.2'     src include -rI --files-with-match | xargs sed -i -e '
      s@"libasound\.so\.2"@"${alsa-lib.out}/lib/libasound.so.2"@g'

    export USER=nix
    set +x
  '';

  patches =
     optional enableHardening ./hardened.patch
     # Since VirtualBox 7.0.8, VBoxSDL requires SDL2, but the build framework uses SDL1
  ++ optional (!headless) ./fix-sdl.patch
  ++ [ ./extra_symbols.patch ]
     # When hardening is enabled, we cannot use wrapQtApp to ensure that VirtualBoxVM sees
     # the correct environment variables needed for Qt to work, specifically QT_PLUGIN_PATH.
     # This is because VirtualBoxVM would detect that it is wrapped that and refuse to run,
     # and also because it would unset QT_PLUGIN_PATH for security reasons. We work around
     # these issues by patching the code to set QT_PLUGIN_PATH to the necessary paths,
     # after the code that unsets it. Note that qtsvg is included so that SVG icons from
     # the user's icon theme can be loaded.
  ++ optional (!headless && enableHardening) (substituteAll {
      src = ./qt-env-vars.patch;
      qtPluginPath = "${qtbase.bin}/${qtbase.qtPluginPrefix}:${qtsvg.bin}/${qtbase.qtPluginPrefix}:${qtwayland.bin}/${qtbase.qtPluginPrefix}";
    })
  ++ [
    ./qt-dependency-paths.patch
    # https://github.com/NixOS/nixpkgs/issues/123851
    ./fix-audio-driver-loading.patch
  ];

  postPatch = ''
    sed -i -e 's|/sbin/ifconfig|${nettools}/bin/ifconfig|' \
      src/VBox/HostDrivers/adpctl/VBoxNetAdpCtl.cpp
  '' + optionalString headless ''
    # Fix compile error in version 6.1.6
    substituteInPlace src/VBox/HostServices/SharedClipboard/VBoxSharedClipboardSvc-x11-stubs.cpp \
      --replace PSHCLFORMATDATA PSHCLFORMATS
  '';

  # first line: ugly hack, and it isn't yet clear why it's a problem
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
    ${optionalString javaBindings ''
    VBOX_JAVA_HOME                 := ${jdk}
    ''}
    ${optionalString (!headless) ''
    VBOX_WITH_VBOXSDL              := 1
    PATH_QT5_X11_EXTRAS_LIB        := ${getLib qtx11extras}/lib
    PATH_QT5_X11_EXTRAS_INC        := ${getDev qtx11extras}/include
    PATH_QT5_TOOLS_LIB             := ${getLib qttools}/lib
    PATH_QT5_TOOLS_INC             := ${getDev qttools}/include
    ''}
    ${optionalString enableWebService ''
    # fix gsoap missing zlib include and produce errors with --as-needed
    VBOX_GSOAP_CXX_LIBS := gsoapssl++ z
    ''}
    TOOL_QT5_LRC                   := ${getDev qttools}/bin/lrelease
    LOCAL_CONFIG

    ./configure \
      ${optionalString headless "--build-headless"} \
      ${optionalString (!javaBindings) "--disable-java"} \
      ${optionalString (!pythonBindings) "--disable-python"} \
      ${optionalString (!pulseSupport) "--disable-pulse"} \
      ${optionalString (!enableHardening) "--disable-hardening"} \
      ${optionalString (!enable32bitGuests) "--disable-vmmraw"} \
      ${optionalString enableWebService "--enable-webservice"} \
      ${optionalString (open-watcom-bin != null) "--with-ow-dir=${open-watcom-bin}"} \
      --disable-kmods
    sed -e 's@PKG_CONFIG_PATH=.*@PKG_CONFIG_PATH=${libIDL}/lib/pkgconfig:${glib.dev}/lib/pkgconfig ${libIDL}/bin/libIDL-config-2@' \
        -i AutoConfig.kmk
    sed -e 's@arch/x86/@@' \
        -i Config.kmk
    substituteInPlace Config.kmk --replace "VBOX_WITH_TESTCASES = 1" "#"
  '';

  enableParallelBuilding = true;

  buildPhase = ''
    source env.sh
    kmk -j $NIX_BUILD_CORES BUILD_TYPE="${buildType}"
  '';

  installPhase = ''
    libexec="$out/libexec/virtualbox"
    share="${if enableHardening then "$out/share/virtualbox" else "$libexec"}"

    # Install VirtualBox files
    mkdir -p "$libexec"
    find out/linux.*/${buildType}/bin -mindepth 1 -maxdepth 1 \
      -name src -o -exec cp -avt "$libexec" {} +

    mkdir -p $out/bin
    for file in ${optionalString (!headless) "VirtualBox VBoxSDL"} ${optionalString enableWebService "vboxwebsrv"} VBoxManage VBoxBalloonCtrl VBoxHeadless; do
        echo "Linking $file to /bin"
        test -x "$libexec/$file"
        ln -s "$libexec/$file" $out/bin/$file
    done

    ${optionalString (extensionPack != null) ''
      mkdir -p "$share"
      "${fakeroot}/bin/fakeroot" "${stdenv.shell}" <<EOF
      "$libexec/VBoxExtPackHelperApp" install \
        --base-dir "$share/ExtensionPacks" \
        --cert-dir "$share/ExtPackCertificates" \
        --name "Oracle VM VirtualBox Extension Pack" \
        --tarball "${extensionPack}" \
        --sha-256 "${extensionPack.outputHash}"
      EOF
    ''}

    ${optionalString (!headless) ''
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
      # Translation
      ln -sv $libexec/nls "$out/share/virtualbox"
    ''}

    cp -rv out/linux.*/${buildType}/bin/src "$modsrc"

    mkdir -p "$out/share/virtualbox"
    cp -rv src/VBox/Main/UnattendedTemplates "$out/share/virtualbox"
    ln -s "${linuxPackages.virtualboxGuestAdditions.src}" "$out/share/virtualbox/VBoxGuestAdditions.iso"
  '';

  preFixup = optionalString (!headless) ''
    wrapQtApp $out/bin/VirtualBox
  ''
  # If hardening is disabled, wrap the VirtualBoxVM binary instead of patching
  # the source code (see postPatch).
  + optionalString (!headless && !enableHardening) ''
    wrapQtApp $out/libexec/virtualbox/VirtualBoxVM
  '';

  passthru = {
    inherit version;       # for guest additions
    inherit extensionPack; # for inclusion in profile to prevent gc
    updateScript = ./update.sh;
  };

  meta = {
    description = "PC emulator";
    longDescription = ''
      VirtualBox is an x86 and AMD64/Intel64 virtualization product for enterprise and home use.

      To install on NixOS, please use the option `virtualisation.virtualbox.host.enable = true`.
      Please also check other options under `virtualisation.virtualbox`.
    '';
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    license = licenses.gpl2;
    homepage = "https://www.virtualbox.org/";
    maintainers = with maintainers; [ sander ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "VirtualBox";
  };
}
