{ lib, stdenv, libXcomposite, libgnome-keyring, makeWrapper, udev, curlWithGnuTls, alsa-lib
, libXfixes, atk, gtk3, libXrender, pango, gnome, cairo, freetype, fontconfig
, libX11, libXi, libxcb, libXext, libXcursor, glib, libXScrnSaver, libxkbfile, libXtst
, nss, nspr, cups, fetchzip, expat, gdk-pixbuf, libXdamage, libXrandr, dbus
, makeDesktopItem, openssl, wrapGAppsHook, at-spi2-atk, at-spi2-core, libuuid
, e2fsprogs, krb5, libdrm, mesa, unzip, copyDesktopItems, libxshmfence, libxkbcommon, git
, libGL, zlib, cacert
}:

with lib;

let
  pname = "gitkraken";
  version = "9.11.1";

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  srcs = {
    x86_64-linux = fetchzip {
      url = "https://release.axocdn.com/linux/GitKraken-v${version}.tar.gz";
      hash = "sha256-DTnVsVWOPAcG2O87dS6PwAB+VU0ijulELHe9CnOLYPU=";
    };

    x86_64-darwin = fetchzip {
      url = "https://release.axocdn.com/darwin/GitKraken-v${version}.zip";
      hash = "sha256-JkmQYk+t4ACkK3V0IxrrIcheBWJEkxQzf9ZYRWs769c=";
    };

    aarch64-darwin = fetchzip {
      url = "https://release.axocdn.com/darwin-arm64/GitKraken-v${version}.zip";
      hash = "sha256-jWXvDSyM7A3+cer/yPvom9f0w2nGJmwOJ22qoQzRWGQ=";
    };
  };

  src = srcs.${stdenv.hostPlatform.system} or throwSystem;

  meta = {
    homepage = "https://www.gitkraken.com/";
    description = "The downright luxurious and most popular Git client for Windows, Mac & Linux";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = builtins.attrNames srcs;
    maintainers = with maintainers; [ xnwdd evanjs arkivm nicolas-goudry ];
    mainProgram = "gitkraken";
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version src meta;

    dontBuild = true;
    dontConfigure = true;

    libPath = makeLibraryPath [
      stdenv.cc.cc.lib
      curlWithGnuTls
      udev
      libX11
      libXext
      libXcursor
      libXi
      libxcb
      glib
      libXScrnSaver
      libxkbfile
      libXtst
      nss
      nspr
      cups
      alsa-lib
      expat
      gdk-pixbuf
      dbus
      libXdamage
      libXrandr
      atk
      pango
      cairo
      freetype
      fontconfig
      libXcomposite
      libXfixes
      libXrender
      gtk3
      libgnome-keyring
      openssl
      at-spi2-atk
      at-spi2-core
      libuuid
      e2fsprogs
      krb5
      libdrm
      mesa
      libxshmfence
      libxkbcommon
      libGL
      zlib
    ];

    desktopItems = [ (makeDesktopItem {
      name = "GitKraken";
      exec = "gitkraken";
      icon = "gitkraken";
      desktopName = "GitKraken";
      genericName = "Git Client";
      categories = [ "Development" ];
      comment = "Graphical Git client from Axosoft";
    }) ];

    nativeBuildInputs = [ copyDesktopItems makeWrapper wrapGAppsHook ];
    buildInputs = [ gtk3 gnome.adwaita-icon-theme ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/${pname}/
      cp -R $src/* $out/share/${pname}

      mkdir -p $out/share/pixmaps
      cp gitkraken.png $out/share/pixmaps/

      runHook postInstall
    '';

    postFixup = ''
      pushd $out/share/${pname}
      for file in gitkraken chrome-sandbox chrome_crashpad_handler; do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $file
      done

      for file in $(find . -type f \( -name \*.node -o -name gitkraken -o -name git -o -name git-\* -o -name scalar -o -name \*.so\* \) ); do
        patchelf --set-rpath ${libPath}:$out/share/${pname} $file || true
      done
      popd

      # SSL and permissions fix for bundled nodegit
      pushd $out/share/${pname}/resources/app.asar.unpacked/node_modules/@axosoft/nodegit/build/Release
      mv nodegit-ubuntu-18.node nodegit-ubuntu-18-ssl-1.1.1.node
      mv nodegit-ubuntu-18-ssl-static.node nodegit-ubuntu-18.node
      chmod 755 nodegit-ubuntu-18.node
      popd

      # Devendor bundled git
      rm -rf $out/share/${pname}/resources/app.asar.unpacked/git
      ln -s ${git} $out/share/${pname}/resources/app.asar.unpacked/git

      # GitKraken expects the CA bundle to be located in the bundled git directory. Since we replace it with
      # the one from nixpkgs, which doesn't provide a CA bundle, we need to explicitly set its location at runtime
      makeWrapper $out/share/${pname}/gitkraken $out/bin/gitkraken --set GIT_SSL_CAINFO "${cacert}/etc/ssl/certs/ca-bundle.crt"
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ unzip ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications/GitKraken.app
      cp -R . $out/Applications/GitKraken.app

      runHook postInstall
    '';

    dontFixup = true;
  };
in
if stdenv.isDarwin
then darwin
else linux
