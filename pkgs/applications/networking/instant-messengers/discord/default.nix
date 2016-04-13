{ stdenv, fetchurl
, alsaLib, atk, cairo, cups, dbus, expat, fontconfig, freetype, gdk_pixbuf
, glib, gnome, gtk, libnotify, libX11, libXcomposite, libXcursor, libXdamage
, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst, nspr, nss, pango
, libudev }:

let version = "0.0.1"; in

stdenv.mkDerivation {

    name = "discord-${version}";

    src = fetchurl {
        url = "https://storage.googleapis.com/discord-developer/test/discord-canary-${version}.tar.gz";
        sha256 = "1skmwc84s4xqyc167qrplhy5ah06kwfa3d3rxiwi4c8rc55vdd0g";
    };

    libPath = stdenv.lib.makeLibraryPath [
        stdenv.cc.cc alsaLib atk cairo cups dbus expat fontconfig freetype
        gdk_pixbuf glib gnome.GConf gtk libnotify libX11 libXcomposite
        libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
        libXtst nspr nss pango libudev
     ];

    installPhase = ''
        mkdir -p $out/bin
        mv * $out

        # Copying how adobe-reader does it,
        # see pkgs/applications/misc/adobe-reader/builder.sh
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                 --set-rpath "$out:$libPath"                                   \
                 $out/DiscordCanary

        ln -s $out/DiscordCanary $out/bin/

        # Putting udev in the path won't work :(
        ln -s ${libudev}/lib/libudev.so.1 $out
        '';

    meta = with stdenv.lib; {
        description = "All-in-one voice and text chat for gamers that’s free, secure, and works on both your desktop and phone";
        homepage = "https://discordapp.com/";
        license = licenses.unfree;
        maintainers = [ maintainers.ldesgoui ];
        platforms = [ "x86_64-linux" ];
    };
}
