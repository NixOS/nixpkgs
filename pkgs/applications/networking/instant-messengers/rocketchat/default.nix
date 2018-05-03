{ stdenv, fetchurl, dpkg, alsaLib, atk, cairo, 
  cups, curl, dbus, expat, fontconfig, freetype, glib,
  gnome2, libnotify, libxcb, nspr, nss, systemd, xorg 
}:

let version = "2.10.5";
    rpath = stdenv.lib.makeLibraryPath  [ 
      alsaLib
      atk
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      glib
      gnome2.GConf
      gnome2.gdk_pixbuf
      gnome2.gtk
      gnome2.pango
      libnotify
      libxcb
      nspr
      nss
      stdenv.cc.cc
      systemd
      
      xorg.libxkbfile
      xorg.libX11
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libXScrnSaver ] + ":${stdenv.cc.cc.lib}/lib64";

    src = fetchurl {
                     url = "https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/${version}/rocketchat_${version}_amd64.deb";
                     sha256 = "907de38c44a1663223bd43cc63b2a1347d9e08c72e248c736f9c88b995ddf583";
                   };

in stdenv.mkDerivation {
   name = "rocketchat-${version}";
   inherit src;
   buildInputs = [ dpkg ];
   unpackPhase = true;

   buildCommand = ''
    mkdir -p $out $out/bin $out/lib
    dpkg -x $src $out
    mv $out/usr/share $out/share
    mv $out/opt/Rocket.Chat+ $out/lib/rocketchat
    rm -rf $out/usr $out/opt

    # Otherwise it looks "suspicious"
    chmod -R g-w $out

    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath}:$out/lib/rocketchat $file || true
    done

    ln -s $out/lib/rocketchat/rocketchat $out/bin/rocketchat

    # Fix the desktop link
    substituteInPlace $out/share/applications/rocketchat.desktop \
      --replace /opt/Rocket.Chat+/rocketchat $out/bin/rocketchat

    # Fix electron-updater warnings, must take exact same amount of
    # characters, otherwise the aspar archive breaks
    sed -i 's/    checkForUpdates();/\/\/  checkForUpdates();/' \
        $out/lib/rocketchat/resources/app.asar
    
  '';
   
  meta = with stdenv.lib; {
    description = "Desktop client for Rocket.Chat";
    homepage = https://rocket.chat;
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.hlolli ];
  };

}
