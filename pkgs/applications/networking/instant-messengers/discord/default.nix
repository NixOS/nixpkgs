{ stdenv, fetchurl, makeDesktopItem, makeWrapper
, alsaLib, atk, cairo, cups, dbus, expat, fontconfig, freetype, gdk_pixbuf
, glib, gnome2, gtk2, libnotify, libX11, libXcomposite, libXcursor, libXdamage
, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst, nspr, nss, libxcb
, pango, systemd, libXScrnSaver, libcxx, libpulseaudio }:

stdenv.mkDerivation rec {

    pname = "discord";
    version = "0.0.4";
    name = "${pname}-${version}";

    src = fetchurl {
        url = "https://cdn.discordapp.com/apps/linux/${version}/${pname}-${version}.tar.gz";
        sha256 = "1alw9rkv1vv0s1w33hd9ab1cgj7iqd7ad9kvn1d55gyki28f8qlb";
    };

    nativeBuildInputs = [ makeWrapper ];

    libPath = stdenv.lib.makeLibraryPath [
        libcxx systemd libpulseaudio
        stdenv.cc.cc alsaLib atk cairo cups dbus expat fontconfig freetype
        gdk_pixbuf glib gnome2.GConf gtk2 libnotify libX11 libXcomposite
        libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
        libXtst nspr nss libxcb pango systemd libXScrnSaver
     ];

    installPhase = ''
        mkdir -p $out/{bin,opt/discord,share/pixmaps}
        mv * $out/opt/discord

        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                 $out/opt/discord/Discord

        paxmark m $out/opt/discord/Discord

        wrapProgram $out/opt/discord/Discord --prefix LD_LIBRARY_PATH : ${libPath}

        ln -s $out/opt/discord/Discord $out/bin/
        ln -s $out/opt/discord/discord.png $out/share/pixmaps

        ln -s "${desktopItem}/share/applications" $out/share/
        '';

    desktopItem = makeDesktopItem {
      name = pname;
      exec = "Discord";
      icon = pname;
      desktopName = "Discord";
      genericName = meta.description;
      categories = "Network;InstantMessaging;";
    };

    meta = with stdenv.lib; {
        description = "All-in-one voice and text chat for gamers that’s free, secure, and works on both your desktop and phone";
        homepage = https://discordapp.com/;
        downloadPage = "https://github.com/crmarsh/discord-linux-bugs";
        license = licenses.unfree;
        maintainers = [ maintainers.ldesgoui maintainers.MP2E ];
        platforms = [ "x86_64-linux" ];
    };
}
