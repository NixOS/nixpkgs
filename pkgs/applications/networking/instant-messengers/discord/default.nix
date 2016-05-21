{ stdenv, fetchurl
, alsaLib, atk, cairo, cups, dbus, expat, fontconfig, freetype, gdk_pixbuf
, glib, gnome, gtk, libnotify, libX11, libXcomposite, libXcursor, libXdamage
, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst, nspr, nss, pango
, libudev, libXScrnSaver }:

let version = "0.0.8"; in

stdenv.mkDerivation {

    name = "discord-${version}";

    src = fetchurl {
        url = "https://cdn-canary.discordapp.com/apps/linux/${version}/discord-canary-${version}.tar.gz";
        sha256 = "1g48jxiswpfvbgjs4dyywmzj9kncvrgpajhixk3acizdmfmsyqkk";
    };

    libPath = stdenv.lib.makeLibraryPath [
        stdenv.cc.cc alsaLib atk cairo cups dbus expat fontconfig freetype
        gdk_pixbuf glib gnome.GConf gtk libnotify libX11 libXcomposite
        libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
        libXtst nspr nss pango libudev.out libXScrnSaver
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
        ln -s ${libudev.out}/lib/libudev.so.1 $out
        '';

    meta = with stdenv.lib; {
        description = "All-in-one voice and text chat for gamers that’s free, secure, and works on both your desktop and phone";
        homepage = "https://discordapp.com/";
        downloadPage = "https://github.com/crmarsh/discord-linux-bugs";
        license = licenses.unfree;
        maintainers = [ maintainers.ldesgoui ];
        platforms = [ "x86_64-linux" ];
    };
}
