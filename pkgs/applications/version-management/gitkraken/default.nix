{ lib, stdenv, libXcomposite, libgnome-keyring, makeWrapper, udev, curlWithGnuTls, alsa-lib
, libXfixes, atk, gtk3, libXrender, pango, gnome, cairo, freetype, fontconfig
, libX11, libXi, libxcb, libXext, libXcursor, glib, libXScrnSaver, libxkbfile, libXtst
, nss, nspr, cups, fetchzip, expat, gdk-pixbuf, libXdamage, libXrandr, dbus
, makeDesktopItem, openssl, wrapGAppsHook, at-spi2-atk, at-spi2-core, libuuid
, e2fsprogs, krb5, libdrm, mesa, unzip, copyDesktopItems, libxshmfence, libxkbcommon
}:

with lib;

let
  pname = "gitkraken";
  version = "9.3.0";

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  srcs = {
    x86_64-linux = fetchzip {
      url = "https://release.axocdn.com/linux/GitKraken-v${version}.tar.gz";
      sha256 = "sha256-OX/taX+eYHPWTNNGfZhoiBEG8pFSnjCaTshM+z6MhDU=";
    };

    x86_64-darwin = fetchzip {
      url = "https://release.axocdn.com/darwin/GitKraken-v${version}.zip";
      sha256 = "sha256-miUcV35HX73b5YnwMnkqYdQtxfSHJaMdMcgVVBkZs6A=";
    };

    aarch64-darwin = fetchzip {
      url = "https://release.axocdn.com/darwin-arm64/GitKraken-v${version}.zip";
      sha256 = "sha256-yAwvuwxtGQh7/bV/7wShdCVHgZCtRCfmXrdT4dI6+cM=";
    };
  };

  src = srcs.${stdenv.hostPlatform.system} or throwSystem;

  meta = {
    homepage = "https://www.gitkraken.com/";
    description = "The downright luxurious and most popular Git client for Windows, Mac & Linux";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = builtins.attrNames srcs;
    maintainers = with maintainers; [ xnwdd evanjs arkivm ];
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
    ];

    desktopItems = [ (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
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

      mkdir -p $out/bin
      ln -s $out/share/${pname}/${pname} $out/bin/

      mkdir -p $out/share/pixmaps
      cp ${pname}.png $out/share/pixmaps/${pname}.png

      runHook postInstall
    '';

    postFixup = ''
      pushd $out/share/${pname}
      for file in ${pname} chrome-sandbox chrome_crashpad_handler; do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $file
      done

      for file in $(find . -type f \( -name \*.node -o -name ${pname} -o -name \*.so\* \) ); do
        patchelf --set-rpath ${libPath}:$out/share/${pname} $file || true
      done
      popd
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ unzip ];

    installPhase = ''
      mkdir -p $out/Applications/GitKraken.app
      cp -R . $out/Applications/GitKraken.app
    '';
  };
in
if stdenv.isDarwin
then darwin
else linux
