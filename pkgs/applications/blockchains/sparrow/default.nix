{ stdenv
, lib
, makeWrapper
, fetchurl
, makeDesktopItem
, copyDesktopItems
, autoPatchelfHook
, openjdk
, gtk3
, gsettings-desktop-schemas
, writeScript
, bash
, gnugrep
, tor
, zlib
, openimajgrabber
, hwi
, imagemagick
, gzip
}:

let
  pname = "sparrow";
  version = "1.7.6";

  src = fetchurl {
    url = "https://github.com/sparrowwallet/${pname}/releases/download/${version}/${pname}-${version}-x86_64.tar.gz";
    sha256 = "01ksl790i8swvj8nvl2r27bbd8kad80shsbw3di39925841dp8z3";
  };

  launcher = writeScript "sparrow" ''
    #! ${bash}/bin/bash
    params=(
      --module-path @out@/lib:@jdkModules@/modules
      --add-opens javafx.graphics/com.sun.javafx.css=org.controlsfx.controls
      --add-opens javafx.graphics/javafx.scene=org.controlsfx.controls
      --add-opens javafx.controls/com.sun.javafx.scene.control.behavior=org.controlsfx.controls
      --add-opens javafx.controls/com.sun.javafx.scene.control.inputmap=org.controlsfx.controls
      --add-opens javafx.graphics/com.sun.javafx.scene.traversal=org.controlsfx.controls
      --add-opens javafx.base/com.sun.javafx.event=org.controlsfx.controls
      --add-opens javafx.controls/javafx.scene.control.cell=com.sparrowwallet.sparrow
      --add-opens org.controlsfx.controls/impl.org.controlsfx.skin=com.sparrowwallet.sparrow
      --add-opens org.controlsfx.controls/impl.org.controlsfx.skin=javafx.fxml
      --add-opens javafx.graphics/com.sun.javafx.tk=centerdevice.nsmenufx
      --add-opens javafx.graphics/com.sun.javafx.tk.quantum=centerdevice.nsmenufx
      --add-opens javafx.graphics/com.sun.glass.ui=centerdevice.nsmenufx
      --add-opens javafx.controls/com.sun.javafx.scene.control=centerdevice.nsmenufx
      --add-opens javafx.graphics/com.sun.javafx.menu=centerdevice.nsmenufx
      --add-opens javafx.graphics/com.sun.glass.ui=com.sparrowwallet.sparrow
      --add-opens javafx.graphics/com.sun.javafx.application=com.sparrowwallet.sparrow
      --add-opens java.base/java.net=com.sparrowwallet.sparrow
      --add-opens java.base/java.io=com.google.gson
      --add-reads com.sparrowwallet.merged.module=java.desktop
      --add-reads com.sparrowwallet.merged.module=java.sql
      --add-reads com.sparrowwallet.merged.module=com.sparrowwallet.sparrow
      --add-reads com.sparrowwallet.merged.module=logback.classic
      --add-reads com.sparrowwallet.merged.module=com.fasterxml.jackson.databind
      --add-reads com.sparrowwallet.merged.module=com.fasterxml.jackson.annotation
      --add-reads com.sparrowwallet.merged.module=com.fasterxml.jackson.core
      --add-reads com.sparrowwallet.merged.module=co.nstant.in.cbor
      -m com.sparrowwallet.sparrow
    )

    XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS ${openjdk}/bin/java ''${params[@]} $@
  '';

  torWrapper = writeScript "tor-wrapper" ''
    #! ${bash}/bin/bash

    exec ${tor}/bin/tor "$@"
  '';

  jdk-modules = stdenv.mkDerivation {
    name = "jdk-modules";
    nativeBuildInputs = [ openjdk ];
    dontUnpack = true;

    buildPhase = ''
      # Extract the JDK's JIMAGE and generate a list of modules.
      mkdir modules
      pushd modules
      jimage extract ${openjdk}/lib/openjdk/lib/modules
      ls | xargs -d " " -- echo > ../manifest.txt
      popd
    '';

    installPhase = ''
      mkdir -p $out
      cp manifest.txt $out/
      cp -r modules/ $out/
    '';
  };

  sparrow-modules = stdenv.mkDerivation {
    pname = "sparrow-modules";
    inherit version src;
    nativeBuildInputs = [ makeWrapper gzip gnugrep openjdk autoPatchelfHook stdenv.cc.cc.lib zlib ];

    buildPhase = ''
      # Extract Sparrow's JIMAGE and generate a list of them.
      mkdir modules
      pushd modules
      jimage extract ../lib/runtime/lib/modules

      # Delete JDK modules
      cat ${jdk-modules}/manifest.txt | xargs -I {} -- rm -fR {}

      # Delete unneeded native libs.

      rm -fR com.sparrowwallet.merged.module/com/sun/jna/freebsd-x86-64
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/freebsd-x86
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/linux-aarch64
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/linux-arm
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/linux-armel
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/linux-mips64el
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/linux-ppc
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/linux-ppc64le
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/linux-s390x
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/linux-x86
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/openbsd-x86-64
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/openbsd-x86
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/sunos-sparc
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/sunos-sparcv9
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/sunos-x86-64
      rm -fR com.sparrowwallet.merged.module/com/sun/jna/sunos-x86
      rm -fR com.github.sarxos.webcam.capture/com/github/sarxos/webcam/ds/buildin/lib/linux_armel
      rm -fR com.github.sarxos.webcam.capture/com/github/sarxos/webcam/ds/buildin/lib/linux_armhf
      rm -fR com.github.sarxos.webcam.capture/com/github/sarxos/webcam/ds/buildin/lib/linux_x86
      rm com.github.sarxos.webcam.capture/com/github/sarxos/webcam/ds/buildin/lib/linux_x64/OpenIMAJGrabber.so
      rm -fR com.nativelibs4java.bridj/org/bridj/lib/linux_arm32_armel
      rm -fR com.nativelibs4java.bridj/org/bridj/lib/linux_armel
      rm -fR com.nativelibs4java.bridj/org/bridj/lib/linux_armhf
      rm -fR com.nativelibs4java.bridj/org/bridj/lib/linux_x86
      rm -fR com.nativelibs4java.bridj/org/bridj/lib/sunos_x64
      rm -fR com.nativelibs4java.bridj/org/bridj/lib/sunos_x86
      rm -fR com.sparrowwallet.merged.module/linux-aarch64
      rm -fR com.sparrowwallet.merged.module/linux-arm
      rm -fR com.sparrowwallet.merged.module/linux-x86
      rm com.sparrowwallet.sparrow/native/linux/x64/hwi

      ls | xargs -d " " -- echo > ../manifest.txt
      find . | grep "\.so$" | xargs -- chmod ugo+x
      popd

      # Replace the embedded Tor binary (which is in a Tar archive)
      # with one from Nixpkgs.
      gzip -c ${torWrapper}  > tor.gz
      cp tor.gz modules/kmp.tor.binary.linuxx64/kmptor/linux/x64/tor.gz
      find modules
    '';

    installPhase = ''
      mkdir -p $out
      cp manifest.txt $out/
      cp -r modules/ $out/
      ln -s ${openimajgrabber}/lib/OpenIMAJGrabber.so $out/modules/com.github.sarxos.webcam.capture/com/github/sarxos/webcam/ds/buildin/lib/linux_x64/OpenIMAJGrabber.so
      ln -s ${hwi}/bin/hwi $out/modules/com.sparrowwallet.sparrow/native/linux/x64/hwi
    '';
  };
in
stdenv.mkDerivation rec {
  inherit version src;
  pname = "sparrow-unwrapped";
  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      name = "Sparrow";
      exec = pname;
      icon = pname;
      desktopName = "Sparrow Bitcoin Wallet";
      genericName = "Bitcoin Wallet";
      categories = [ "Finance" "Network" ];
      mimeTypes = [ "application/psbt" "application/bitcoin-transaction" "x-scheme-handler/bitcoin" "x-scheme-handler/auth47" "x-scheme-handler/lightning" ];
      startupWMClass = "Sparrow";
    })
  ];

  sparrow-icons = stdenv.mkDerivation {
    inherit version src;
    pname = "sparrow-icons";
    nativeBuildInputs = [ imagemagick ];

    installPhase = ''
      for n in 16 24 32 48 64 96 128 256; do
        size=$n"x"$n
        mkdir -p $out/hicolor/$size/apps
        convert lib/Sparrow.png -resize $size $out/hicolor/$size/apps/sparrow.png
        done;
    '';
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out
    ln -s ${sparrow-modules}/modules $out/lib
    install -D -m 777 ${launcher} $out/bin/sparrow
    substituteAllInPlace $out/bin/sparrow
    substituteInPlace $out/bin/sparrow --subst-var-by jdkModules ${jdk-modules}

    mkdir -p $out/share/icons
    ln -s ${sparrow-icons}/hicolor $out/share/icons

    mkdir -p $out/etc/udev/rules.d
    cp ${hwi}/lib/python*/site-packages/hwilib/udev/*.rules $out/etc/udev/rules.d

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A modern desktop Bitcoin wallet application supporting most hardware wallets and built on common standards such as PSBT, with an emphasis on transparency and usability.";
    homepage = "https://sparrowwallet.com";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ emmanuelrosa _1000101 ];
    platforms = [ "x86_64-linux" ];
  };
}
