{
  stdenv,
  stdenvNoCC,
  lib,
  makeWrapper,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  zulu25,
  gtk3,
  gsettings-desktop-schemas,
  writeScript,
  bash,
  gnugrep,
  tor,
  zlib,
  imagemagick,
  gzip,
  gnupg,
  libusb1,
  pcsclite,
  udevCheckHook,
}:

let
  version = "2.5.3";

  openjdk = zulu25.override { enableJavaFX = true; };

  sparrowArch =
    {
      x86_64-linux = "x86_64";
      aarch64-linux = "aarch64";
    }
    ."${stdenvNoCC.hostPlatform.system}";

  javaArch =
    {
      x86_64-linux = "x64";
      aarch64-linux = "aarch64";
    }
    ."${stdenvNoCC.hostPlatform.system}";

  jnaArch =
    {
      x86_64-linux = "x86-64";
      aarch64-linux = "aarch64";
    }
    ."${stdenvNoCC.hostPlatform.system}";

  src = fetchurl {
    url = "https://github.com/sparrowwallet/sparrow/releases/download/${version}/sparrowwallet-${version}-${sparrowArch}.tar.gz";
    hash =
      {
        x86_64-linux = "sha256-xRtMh8nYHzjMyb8zSPQZNIbcfQIuKk4izfPW/PLK2zg=";
        aarch64-linux = "sha256-Kl4SV5MSIfCszUI2uN9/eLK+25gkSWkRHoSf8X837VM=";
      }
      ."${stdenvNoCC.hostPlatform.system}";

    # nativeBuildInputs, downloadToTemp, and postFetch are used to verify the signed upstream package.
    # The signature is not a self-contained file. Instead the SHA256 of the package is added to a manifest file.
    # The manifest file is signed by the owner of the public key, Craig Raw.
    # Thus to verify the signed package, the manifest is verified with the public key,
    # and then the package is verified against the manifest.
    # The public key is obtained from https://keybase.io/craigraw/pgp_keys.asc
    # and is included in this repo to provide reproducibility.
    nativeBuildInputs = [ gnupg ];
    downloadToTemp = true;

    postFetch = ''
      pushd $(mktemp -d)
      export GNUPGHOME=$PWD/gnupg
      mkdir -m 700 -p $GNUPGHOME
      ln -s ${manifest} ./manifest.txt
      ln -s ${manifestSignature} ./manifest.txt.asc
      ln -s $downloadedFile ./sparrowwallet-${version}-${sparrowArch}.tar.gz
      gpg --import ${publicKey}
      gpg --verify manifest.txt.asc manifest.txt
      sha256sum -c --ignore-missing manifest.txt
      popd
      mv $downloadedFile $out
    '';
  };

  manifest = fetchurl {
    url = "https://github.com/sparrowwallet/sparrow/releases/download/${version}/sparrow-${version}-manifest.txt";
    hash = "sha256-oVR5lJOWHTyEe+fBbxa+ZPh9GERHlZbZMPmaGImmdhg=";
  };

  manifestSignature = fetchurl {
    url = "https://github.com/sparrowwallet/sparrow/releases/download/${version}/sparrow-${version}-manifest.txt.asc";
    hash = "sha256-9ohRv/3rcOr78Mr0Bfny9zn+SqpLFaf0hn9G2LMAc8Q=";
  };

  publicKey = ./publickey.asc;

  launcher = writeScript "sparrow" ''
    #! ${bash}/bin/bash
    params=(
      -Dsun.security.smartcardio.library=${pcsclite.lib}/lib/libpcsclite.so.1
      --module-path @out@/lib:@jdkModules@/modules
      --add-opens=javafx.graphics/com.sun.javafx.css=org.controlsfx.controls
      --add-opens=javafx.graphics/javafx.scene=org.controlsfx.controls
      --add-opens=javafx.controls/com.sun.javafx.scene.control.behavior=org.controlsfx.controls
      --add-opens=javafx.controls/com.sun.javafx.scene.control.inputmap=org.controlsfx.controls
      --add-opens=javafx.graphics/com.sun.javafx.scene.traversal=org.controlsfx.controls
      --add-opens=javafx.base/com.sun.javafx.event=org.controlsfx.controls
      --add-opens=javafx.controls/javafx.scene.control.cell=com.sparrowwallet.sparrow
      --add-opens=org.controlsfx.controls/impl.org.controlsfx.skin=com.sparrowwallet.sparrow
      --add-opens=org.controlsfx.controls/impl.org.controlsfx.skin=javafx.fxml
      --add-opens=javafx.graphics/com.sun.javafx.tk=nsmenufx
      --add-opens=javafx.graphics/com.sun.javafx.tk.quantum=nsmenufx
      --add-opens=javafx.graphics/com.sun.glass.ui=nsmenufx
      --add-opens=javafx.controls/com.sun.javafx.scene.control=nsmenufx
      --add-opens=javafx.graphics/com.sun.javafx.menu=nsmenufx
      --add-opens=javafx.graphics/com.sun.glass.ui=com.sparrowwallet.sparrow
      --add-opens=javafx.graphics/javafx.scene.input=com.sparrowwallet.sparrow
      --add-opens=javafx.graphics/com.sun.javafx.application=com.sparrowwallet.sparrow
      --add-opens=java.base/java.net=com.sparrowwallet.sparrow
      --add-opens=java.base/java.io=com.google.gson
      --add-opens=java.smartcardio/sun.security.smartcardio=com.sparrowwallet.sparrow
      --add-reads=com.sparrowwallet.merged.module=java.desktop
      --add-reads=com.sparrowwallet.merged.module=java.sql
      --add-reads=com.sparrowwallet.merged.module=com.sparrowwallet.sparrow
      --add-reads=com.sparrowwallet.merged.module=ch.qos.logback.classic
      --add-reads=com.sparrowwallet.merged.module=org.slf4j
      --add-reads=com.sparrowwallet.merged.module=com.fasterxml.jackson.databind
      --add-reads=com.sparrowwallet.merged.module=com.fasterxml.jackson.annotation
      --add-reads=com.sparrowwallet.merged.module=com.fasterxml.jackson.core
      --add-reads=com.sparrowwallet.merged.module=co.nstant.in.cbor
      --add-reads=kotlin.stdlib=kotlinx.coroutines.core
      --enable-native-access=com.sparrowwallet.drongo
      --enable-native-access=com.sparrowwallet.merged.module
      --enable-native-access=javafx.graphics
      --enable-native-access=com.fazecast.jSerialComm
      --enable-native-access=org.usb4java
      -m com.sparrowwallet.sparrow
    )

    XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS \
    LD_LIBRARY_PATH=@nativeLibs@''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH} \
    ${openjdk}/bin/java "''${params[@]}" "$@"
  '';

  torWrapper = writeScript "tor-wrapper" ''
    #! ${bash}/bin/bash

    exec ${tor}/bin/tor "$@"
  '';

  jdk-modules = stdenvNoCC.mkDerivation {
    name = "jdk-modules";
    nativeBuildInputs = [ openjdk ];
    dontUnpack = true;

    buildPhase = ''
      # Extract the JDK's JIMAGE and generate a list of modules.
      mkdir modules
      pushd modules
      jimage extract ${openjdk}/lib/modules
      ls | xargs -d " " -- echo > ../manifest.txt
      popd
    '';

    installPhase = ''
      mkdir -p $out
      cp manifest.txt $out/
      cp -r modules/ $out/
    '';
  };

  sparrow-modules = stdenvNoCC.mkDerivation {
    pname = "sparrow-modules";
    inherit version src;
    nativeBuildInputs = [
      makeWrapper
      gzip
      gnugrep
      openjdk
      autoPatchelfHook
    ];

    buildInputs = [
      (lib.getLib stdenv.cc.cc)
      zlib
      libusb1
    ];

    buildPhase = ''
      # Extract Sparrow's JIMAGE and generate a list of them.
      mkdir modules
      pushd modules
      jimage extract ../lib/runtime/lib/modules

      # Delete JDK modules
      cat ${jdk-modules}/manifest.txt | xargs -I {} -- rm -fR {}

      # Delete unneeded native libs.

      rm -R com.sparrowwallet.merged.module/com/sun/jna/win32
      rm -R com.fazecast.jSerialComm/FreeBSD
      rm -R com.fazecast.jSerialComm/OpenBSD
      rm -R com.fazecast.jSerialComm/Android
      rm -R com.fazecast.jSerialComm/Solaris
      rm -R com.fazecast.jSerialComm/OSX
      rm -R com.fazecast.jSerialComm/Windows
      rm -R com.fazecast.jSerialComm/Linux/armv5
      rm -R com.fazecast.jSerialComm/Linux/armv6hf
      rm -R com.fazecast.jSerialComm/Linux/armv7hf
      rm -R com.fazecast.jSerialComm/Linux/armv8_32
      rm -R com.fazecast.jSerialComm/Linux/ppc64le
      rm -R com.fazecast.jSerialComm/Linux/x86

      echo "--- Remaining native libraries in modules ---"
      find . -name "*.so" -o -name "*.dll" -o -name "*.dylib" -o -name "*.jnilib" -o -name "*.a"
      echo "--------------------------------------------"

      ls | xargs -d " " -- echo > ../manifest.txt
      find . | grep "\.so$" | xargs -- chmod ugo+x
      popd

      # Provide native libs for LD_LIBRARY_PATH
      mkdir native-libs
      cp lib/runtime/lib/libargon2.so \
         lib/runtime/lib/libbwt_jni.so \
         lib/runtime/lib/libopenpnp-capture.so \
         lib/runtime/lib/libzbar.so \
         native-libs/
      chmod ugo+x native-libs/*.so

      # secp256k1 explicitly looks in java.home/lib or inside the module jar
      mkdir -p modules/com.sparrowwallet.drongo/native/linux/${javaArch}
      cp lib/runtime/lib/libsecp256k1.so modules/com.sparrowwallet.drongo/native/linux/${javaArch}/

      # JNA extracts from resource path
      mkdir -p modules/com.sparrowwallet.merged.module/com/sun/jna/linux-${jnaArch}
      cp lib/runtime/lib/libjnidispatch.so modules/com.sparrowwallet.merged.module/com/sun/jna/linux-${jnaArch}/

      # hidapi extracts from resource path via JNA
      mkdir -p modules/com.sparrowwallet.merged.module/linux-${jnaArch}
      cp lib/runtime/lib/libhidapi.so modules/com.sparrowwallet.merged.module/linux-${jnaArch}/
      cp lib/runtime/lib/libhidapi-libusb.so modules/com.sparrowwallet.merged.module/linux-${jnaArch}/

      # usb4java extracts from resource path
      mkdir -p modules/org.usb4java/org/usb4java/linux-${jnaArch}
      cp lib/runtime/lib/libusb4java.so modules/org.usb4java/org/usb4java/linux-${jnaArch}/

      # jzbar extracts from resource path
      mkdir -p modules/io.github.doblon8.jzbar/native/linux/${javaArch}
      cp lib/runtime/lib/libzbar.so modules/io.github.doblon8.jzbar/native/linux/${javaArch}/

      # openpnp extracts from resource path
      mkdir -p modules/io.github.doblon8.openpnp.capture/native/linux/${javaArch}
      cp lib/runtime/lib/libopenpnp-capture.so modules/io.github.doblon8.openpnp.capture/native/linux/${javaArch}/

      # Replace the embedded Tor binary (which is in a Tar archive)
      # with one from Nixpkgs.
      gzip -c ${torWrapper}  > tor.gz
      cp tor.gz modules/io.matthewnelson.kmp.tor.resource.exec.tor/io/matthewnelson/kmp/tor/resource/exec/tor/native/linux-libc/${sparrowArch}/tor.gz
    '';

    installPhase = ''
      mkdir -p $out
      cp manifest.txt $out/
      cp -r modules/ $out/
      cp -r native-libs/ $out/
    '';
  };
in
stdenvNoCC.mkDerivation rec {
  inherit version src;
  pname = "sparrow";
  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    udevCheckHook
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "sparrow-desktop";
      exec = "sparrow-desktop";
      icon = "sparrow-desktop";
      desktopName = "Sparrow Bitcoin Wallet";
      genericName = "Bitcoin Wallet";
      categories = [
        "Finance"
        "Network"
      ];
      mimeTypes = [
        "application/psbt"
        "application/bitcoin-transaction"
        "x-scheme-handler/bitcoin"
        "x-scheme-handler/auth47"
        "x-scheme-handler/lightning"
      ];
      startupWMClass = "Sparrow";
    })
  ];

  sparrow-icons = stdenvNoCC.mkDerivation {
    inherit version src;
    pname = "sparrow-icons";
    nativeBuildInputs = [ imagemagick ];

    installPhase = ''
      for n in 16 24 32 48 64 96 128 256; do
        size=$n"x"$n
        mkdir -p $out/hicolor/$size/apps
        convert lib/Sparrow.png -resize $size $out/hicolor/$size/apps/sparrow-desktop.png
        done;
    '';
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out
    ln -s ${sparrow-modules}/modules $out/lib
    install -D -m 555 ${launcher} $out/bin/sparrow-desktop
    substituteAllInPlace $out/bin/sparrow-desktop
    substituteInPlace $out/bin/sparrow-desktop \
      --subst-var-by jdkModules ${jdk-modules} \
      --subst-var-by nativeLibs ${sparrow-modules}/native-libs

    mkdir -p $out/share/icons
    ln -s ${sparrow-icons}/hicolor $out/share/icons

    mkdir -p $out/etc/udev/
    ln -s ${sparrow-modules}/modules/com.sparrowwallet.lark/udev $out/etc/udev/rules.d

    runHook postInstall
  '';

  doInstallCheck = true;

  passthru = {
    updateScript = {
      command = [
        ./update.sh
        ./.
      ];
      supportedFeatures = [ "commit" ];
    };
  };

  meta = {
    description = "Modern desktop Bitcoin wallet application supporting most hardware wallets and built on common standards such as PSBT, with an emphasis on transparency and usability";
    homepage = "https://sparrowwallet.com";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      msgilligan
      eymeric
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "sparrow-desktop";
  };
}
