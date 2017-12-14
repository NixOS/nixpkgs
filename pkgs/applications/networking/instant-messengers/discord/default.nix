{ stdenv, fetchurl, makeDesktopItem, makeWrapper
, alsaLib, atk, cairo, cups, dbus, expat, fontconfig, freetype, gdk_pixbuf
, glib, gnome2, gtk2, libnotify, libX11, libXcomposite, libXcursor, libXdamage
, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst, nspr, nss, libxcb
, pango, systemd, libXScrnSaver, libcxx, libpulseaudio }:

stdenv.mkDerivation rec {

    pname = "discord";
    version = "0.0.3";
    name = "${pname}-${version}";

    src = fetchurl {
        url = "https://cdn.discordapp.com/apps/linux/${version}/${name}.tar.gz";
        sha256 = "1yxxy9q75zlgk1b4winw4zy9yxk5pn8x4camh52n6v3mw6gq0bfh";
    };

    nativeBuildInputs = [ makeWrapper ];

    libPath = stdenv.lib.makeLibraryPath [
        stdenv.cc.cc alsaLib atk cairo cups dbus expat fontconfig freetype
        gdk_pixbuf glib gnome2.GConf gtk2 libnotify libX11 libXcomposite
        libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
        libXtst nspr nss libxcb pango systemd libXScrnSaver
     ];

    installPhase = ''
        mkdir -p $out/{bin,opt/discord,share/pixmaps}
        mv * $out/opt/discord

        # Copying how adobe-reader does it,
        # see pkgs/applications/misc/adobe-reader/builder.sh
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                 --set-rpath "$out/opt/discord:$libPath"                                   \
                 $out/opt/discord/Discord

        paxmark m $out/opt/discord/Discord

        wrapProgram $out/opt/discord/Discord --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH:${libcxx}/lib:${systemd.lib}/lib:${libpulseaudio}/lib"

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
