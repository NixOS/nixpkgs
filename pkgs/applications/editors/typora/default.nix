{ stdenv, fetchurl, dpkg, lib, glib, dbus, makeWrapper, gnome2, gnome3, gtk3, atk, cairo, pango
, gdk_pixbuf, freetype, fontconfig, nspr, nss, xorg, alsaLib, cups, expat, udev, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "typora-${version}";
  version = "0.9.53";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://www.typora.io/linux/typora_${version}_amd64.deb";
        sha256 = "02k6x30l4mbjragqbq5rn663xbw3h4bxzgppfxqf5lwydswldklb";
      }
    else
      fetchurl {
        url = "https://www.typora.io/linux/typora_${version}_i386.deb";
        sha256 = "1wyq1ri0wwdy7slbd9dwyrdynsaa644x44c815jl787sg4nhas6y";
      }
    ;

    rpath = stdenv.lib.makeLibraryPath [
      alsaLib
      gnome2.GConf
      gdk_pixbuf
      pango
      gnome3.defaultIconTheme
      expat
      gtk3
      atk
      nspr
      nss
      stdenv.cc.cc
      glib
      cairo
      cups
      dbus
      udev
      fontconfig
      freetype
      xorg.libX11
      xorg.libXi
      xorg.libXext
      xorg.libXtst
      xorg.libXfixes
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXrender
      xorg.libXrandr
      xorg.libXcomposite
      xorg.libxcb
      xorg.libXScrnSaver
  ];

  nativeBuildInputs = [ wrapGAppsHook ];

  dontWrapGApps = true;

  buildInputs = [ dpkg makeWrapper ];

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    mv $out/usr/bin $out
    mv $out/usr/share $out
    rm $out/bin/typora
    rmdir $out/usr

    # Otherwise it looks "suspicious"
    chmod -R g-w $out
  '';

  postFixup = ''
     patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$out/share/typora:${rpath}" "$out/share/typora/Typora"

    makeWrapper $out/share/typora/Typora $out/bin/typora

    wrapProgram $out/bin/typora \
      "''${gappsWrapperArgs[@]}" \
      --suffix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --prefix XDG_DATA_DIRS : "${gnome3.defaultIconTheme}/share"

    # Fix the desktop link
    substituteInPlace $out/share/applications/typora.desktop \
      --replace /usr/bin/ $out/bin/ \
      --replace /usr/share/ $out/share/

  '';

  meta = with stdenv.lib; {
    description = "A minimal Markdown reading & writing app";
    homepage = https://typora.io;
    license = licenses.unfree;
    maintainers = with maintainers; [ jensbin ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
