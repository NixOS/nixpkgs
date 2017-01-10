{ stdenv, fetchurl, makeDesktopItem
, alsaLib, atk, cairo, cups, dbus, expat, fontconfig, freetype, gdk_pixbuf
, glib, gnome2, gtk2, libnotify, libX11, libXcomposite, libXcursor, libXdamage
, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst, nspr, nss, pango
, systemd, libXScrnSaver }:

stdenv.mkDerivation rec {

    pname = "discord";
    version = "0.0.13";
    name = "${pname}-${version}";

    src = fetchurl {
        url = "https://cdn-canary.discordapp.com/apps/linux/${version}/${pname}-canary-${version}.tar.gz";
        sha256 = "1pwb8y80z1bmfln5wd1vrhras0xygd1j15sib0g9vaig4mc55cs6";
    };

    libPath = stdenv.lib.makeLibraryPath [
        stdenv.cc.cc alsaLib atk cairo cups dbus expat fontconfig freetype
        gdk_pixbuf glib gnome2.GConf gtk2 libnotify libX11 libXcomposite
        libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
        libXtst nspr nss pango systemd libXScrnSaver
     ];

    installPhase = ''
        mkdir -p $out/{bin,share/pixmaps}
        mv * $out

        # Copying how adobe-reader does it,
        # see pkgs/applications/misc/adobe-reader/builder.sh
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                 --set-rpath "$out:$libPath"                                   \
                 $out/DiscordCanary

        paxmark m $out/DiscordCanary

        ln -s $out/DiscordCanary $out/bin/
        ln -s $out/discord.png $out/share/pixmaps

        # Putting udev in the path won't work :(
        ln -s ${systemd.lib}/lib/libudev.so.1 $out
        ln -s "${desktopItem}/share/applications" $out/share/
        '';

    desktopItem = makeDesktopItem {
      name = pname;
      exec = "DiscordCanary";
      icon = pname;
      desktopName = "Discord Canary";
      genericName = meta.description;
      categories = "Network;InstantMessaging;";
    };

    meta = with stdenv.lib; {
        description = "All-in-one voice and text chat for gamers that’s free, secure, and works on both your desktop and phone";
        homepage = "https://discordapp.com/";
        downloadPage = "https://github.com/crmarsh/discord-linux-bugs";
        license = licenses.unfree;
        maintainers = [ maintainers.ldesgoui ];
        platforms = [ "x86_64-linux" ];
    };
}
