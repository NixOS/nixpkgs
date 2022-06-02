{
  lib
, pkgs
, stdenv
, fetchzip
, fontconfig
, freetype
, glib
, glib-networking
, gsettings-desktop-schemas
, gtk3
, libsecret
, makeDesktopItem
, makeWrapper
, unzip
, webkitgtk
, xorg
, zlib
}:
stdenv.mkDerivation rec {
  pname = "RCPTT";
  version = "2.5.3";
  src = fetchzip {
    url = "https://download.eclipse.org/rcptt/release/${version}/ide/rcptt.ide-${version}-linux.gtk.x86_64.zip";
    sha256 = "KofgdIHCmi0AeF7oQjp+kvkvuPX6+D7o2Z9U35qwJLA=";
  };

  buildInputs = with xorg; [
    gsettings-desktop-schemas
    makeWrapper
  ];

  desktopItem = makeDesktopItem {
    name = "RCPTT";
    exec = "rcptt";
    icon = "rcptt";
    comment = "RCP Testing Tool is a project for GUI testing automation of Eclipse-based applications.";
    desktopName = "RCPTT";
    genericName = "RCP Testing Tool";
    categories = [ "Development" "IDE" "Java" ];
  };

  unpackPhase = ''
    cp -rp $src/ $out/
  '';

  installPhase = with xorg; ''
    chmod +w $out
    interpreter=$(echo ${pkgs.glibc.out}/lib/ld-linux*.so.2)
    libCairo=$out/eclipse/libcairo-swt.so
    chmod +w $out/rcptt
    patchelf --set-interpreter $interpreter $out/rcptt
    patchelf --set-rpath ${lib.makeLibraryPath [freetype fontconfig gsettings-desktop-schemas libX11 libXrender zlib gtk3 glib-networking webkitgtk]} $out/rcptt
    productId=${pname}
    productVersion=${version}
    export gtk3_version=`echo ${gtk3}  | cut -d '-' -f 3`
    makeWrapper $out/rcptt $out/bin/rcptt \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [glib gtk3 libX11 libXext libXi libXrender libXtst libsecret webkitgtk zlib]} \
      --prefix XDG_DATA_DIRS : "$XDG_DATA_DIRS:${gtk3}/share/gsettings-schemas/gtk+3-$gtk3_version" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --add-flags "-configuration \$HOME/.eclipse/''${productId}_$productVersion/configuration"
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    mkdir -p $out/share/pixmaps
    mv $out/icon.xpm $out/share/pixmaps/rcptt.xpm
  '';

  meta = with lib; {
    homepage = "https://www.eclipse.org/rcptt";
    description = "RCP Testing Tool for Eclipse RCP applications";
    longDescription = ''
      RCP Testing Tool is a project for GUI testing automation of Eclipse-based applications.
      RCPTT is fully aware about Eclipse Platform's internals, hiding this complexity from end users
      and allowing QA engineers to create highly reliable UI tests at great pace.
    '';
    maintainers = with maintainers; [ ngiger ];
    license = licenses.epl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
