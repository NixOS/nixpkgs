{ stdenv, lib, fetchurl, zlib, glib, alsa-lib, makeDesktopItem
, dbus, gtk2, atk, pango, freetype, fontconfig, libgnome-keyring3, gdk-pixbuf
, cairo, cups, expat, libgpg-error, nspr, gnome2, nss, xorg, systemd, libnotify
}:

let
  libPath = lib.makeLibraryPath [
      stdenv.cc.cc zlib glib dbus gtk2 atk pango freetype libgnome-keyring3 nss
      fontconfig gdk-pixbuf cairo cups expat libgpg-error alsa-lib nspr gnome2.GConf
      xorg.libXrender xorg.libX11 xorg.libXext xorg.libXdamage xorg.libXtst
      xorg.libXcomposite xorg.libXi xorg.libXfixes libnotify xorg.libXrandr
      xorg.libXcursor
  ];
  desktopItem = makeDesktopItem {
    name = "LightTable";
    exec = "light";
    comment = "LightTable";
    desktopName = "LightTable";
    genericName = "the next generation code editor";
  };
in

stdenv.mkDerivation rec {
  pname = "lighttable";
  version = "0.8.1";

  src =
      fetchurl {
        name = "LightTableLinux64.tar.gz";
        url = "https://github.com/LightTable/LightTable/releases/download/${version}/${pname}-${version}-linux.tar.gz";
        sha256 = "06fj725xfhf3fwrf7dya7ijmxq3v76kfmd4lr2067a92zhlwr5pv";
      };

  dontConfigure = true;

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/{bin,share/LightTable}
    mv ./${pname}-${version}-linux/* $out/share/LightTable

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath}:${libPath}/lib64:$out/share/LightTable \
      $out/share/LightTable/LightTable

    mv $out/share/LightTable/light $out/bin/light

    ln -sf ${lib.getLib systemd}/lib/libudev.so.1 $out/share/LightTable/libudev.so.0
    substituteInPlace $out/bin/light \
        --replace "/usr/lib/x86_64-linux-gnu" "${lib.getLib systemd}/lib" \
        --replace "/lib/x86_64-linux-gnu" "$out/share/LightTable" \
        --replace 'HERE=`dirname $(readlink -f $0)`' "HERE=$out/share/LightTable"

    mkdir -p "$out"/share/applications
    cp "${desktopItem}/share/applications/LightTable.desktop" "$out"/share/applications/
  '';

  meta = with lib; {
    description = "The next generation code editor";
    homepage = "http://www.lighttable.com/";
    license = licenses.gpl3;
    maintainers = [ maintainers.matejc ];
    platforms = [ "x86_64-linux" ];
  };
}
