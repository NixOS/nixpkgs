{ stdenv
, lib
, requireFile
, makeWrapper
, libredirect
, busybox
, file
, makeDesktopItem
, tzdata
, cacert
, glib
, gtk2
, atk
, gdk_pixbuf
, cairo
, pango
, gnome3
, xlibs
, libpng12
, freetype
, fontconfig
, gtk_engines
, alsaLib
, libidn
, zlib
, version ? null
}:

let
  versionInfo = {
    "13.4.0" = rec {
      major     = "13";
      minor     = "4";
      patch     = "0";
      x64hash   = "133brs0sq6d0mgr19rc6ig1n9ahm3ryi23v5nrgqfh0hgxqcrrjb";
      x86hash   = "0r7jfl5yqv1s2npy8l9gsn0gbb82f6raa092ppkc8xy5pni5sh7l";
      x64suffix = "10109380";
      x86suffix = x64suffix;
      homepage  = https://www.citrix.com/downloads/citrix-receiver/legacy-receiver-for-linux/receiver-for-linux-latest-13-4.html;
    };

    "13.5.0" = rec {
      major     = "13";
      minor     = "5";
      patch     = "0";
      x64hash   = "1r24mhkpcc0z95n597p07fz92pd1b8qqzp2z6w07rmb9wb8mpd4x";
      x86hash   = "0pwxshlryzhkl86cj9ryybm54alhzjx0gpp67fnvdn5r64wy1nd1";
      x64suffix = "10185126";
      x86suffix = x64suffix;
      homepage  = https://www.citrix.com/downloads/citrix-receiver/legacy-receiver-for-linux/receiver-for-linux-latest-13-5.html;
    };

    "13.6.0" = rec {
      major     = "13";
      minor     = "6";
      patch     = "0";
      x64hash   = "6e423be41d5bb8186bcca3fbb4ede54dc3f00b8d2aeb216ae4aabffef9310d34";
      x86hash   = "0ba3eba208b37844904d540b3011075ed5cecf429a0ab6c6cd52f2d0fd841ad2";
      x64suffix = "10243651";
      x86suffix = x64suffix;
      homepage  = https://www.citrix.com/downloads/citrix-receiver/legacy-receiver-for-linux/receiver-for-linux-136.html;
    };

    "13.7.0" = {
      major     = "13";
      minor     = "7";
      patch     = "0";
      x64hash   = "18fb374b9fb8e249b79178500dddca7a1f275411c6537e7695da5dcf19c5ba91";
      x86hash   = "4c68723b0327cf6f12da824056fce2b7853c38e6163a48c9d222b93dd8da75b6";
      x64suffix = "10276927";
      x86suffix = "10276925";
      homepage = https://www.citrix.com/downloads/citrix-receiver/legacy-receiver-for-linux/receiver-for-linux-137.html;
    };

    "13.8.0" = {
      major = "13";
      minor = "8";
      patch = "0";
      x64hash = "FDF5991CCD52B2B98289D7B2FB46D492D3E4032846D4AFA52CAA0F8AC0578931";
      x86hash = "E0CFB43312BF79F753514B11F7B8DE4529823AE4C92D1B01E8A2C34F26AC57E7";
      x64suffix = "10299729";
      x86suffix = "10299729";
      homepage = https://www.citrix.com/downloads/citrix-receiver/linux/receiver-for-linux-latest.html;
    };
  };

  citrixReceiverForVersion = { major, minor, patch, x86hash, x64hash, x86suffix, x64suffix, homepage }:
    stdenv.mkDerivation rec {
      name     = "citrix-receiver-${version}";
      version  = "${major}.${minor}.${patch}";
      inherit homepage;

      prefixWithBitness = if stdenv.is64bit then "linuxx64" else "linuxx86";

      src = requireFile rec {
        name    = if stdenv.is64bit then "${prefixWithBitness}-${version}.${x64suffix}.tar.gz" else "${prefixWithBitness}-${version}.${x86suffix}.tar.gz";
        sha256  = if stdenv.is64bit then x64hash else x86hash;
        message = ''
          In order to use Citrix Receiver, you need to comply with the Citrix EULA and download
          the ${if stdenv.is64bit then "64-bit" else "32-bit"} binaries, .tar.gz from:

          ${homepage}

          (if you do not find version ${version} there, try at
          https://www.citrix.com/downloads/citrix-receiver/legacy-receiver-for-linux/
          or at https://www.citrix.com/downloads/citrix-receiver/ under "Earlier Versions of Receiver for Linux")

          Once you have downloaded the file, please use the following command and re-run the
          installation:

          nix-prefetch-url file://\$PWD/${name}
        '';
      };

      phases = [ "unpackPhase" "installPhase" ];

      sourceRoot = ".";

      buildInputs = [
        makeWrapper
        busybox
        file
        gtk2
        gdk_pixbuf
      ];

      libPath = stdenv.lib.makeLibraryPath [
        glib
        gtk2
        atk
        gdk_pixbuf
        cairo
        pango
        gnome3.dconf
        xlibs.libX11
        xlibs.libXext
        xlibs.libXrender
        xlibs.libXinerama
        xlibs.libXfixes
        libpng12
        libidn
        zlib
        gtk_engines
        freetype
        fontconfig
        alsaLib
        stdenv.cc.cc # Fixes: Can not load [..]/opt/citrix-icaclient/lib/ctxh264_fb.so:(null)
      ];

      desktopItem = makeDesktopItem {
        name        = "wfica";
        desktopName = "Citrix Receiver";
        genericName = "Citrix Receiver";
        exec        = "wfica";
        icon        = "wfica";
        comment     = "Connect to remote Citrix server";
        categories  = "GTK;GNOME;X-GNOME-NetworkSettings;Network;";
        mimeType    = "application/x-ica";
      };

      installPhase = ''
        export ICAInstDir="$out/opt/citrix-icaclient"

        sed -i \
          -e 's,^main_install_menu$,install_ICA_client,g' \
          -e 's,^integrate_ICA_client(),alias integrate_ICA_client=true\nintegrate_ICA_client_old(),g' \
          -e 's,^ANSWER=""$,ANSWER="$INSTALLER_YES",' \
          -e 's,/bin/true,true,g' \
          ./${prefixWithBitness}/hinst

        # Run the installer...
        bash ./${prefixWithBitness}/hinst CDROM "`pwd`"

        echo "Deleting broken links..."
        for link in `find $ICAInstDir -type l `
        do
          [ -f "$link" ] || rm -v "$link"
        done

        echo "Expanding certificates..."
        # As explained in https://wiki.archlinux.org/index.php/Citrix#Security_Certificates
        pushd "$ICAInstDir/keystore/cacerts"
        awk 'BEGIN {c=0;} /BEGIN CERT/{c++} { print > "cert." c ".pem"}' < ${cacert}/etc/ssl/certs/ca-bundle.crt
        popd

        echo "Patching executables..."
        find $ICAInstDir -type f -exec file {} \; |
          grep 'ELF.*executable' |
          cut -f 1 -d : |
          while read f
          do
            echo "Patching ELF intrepreter and rpath for $f"
            chmod u+w "$f"
            patchelf \
              --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
              --set-rpath "$ICAInstDir:$libPath" "$f"
          done

        echo "Wrapping wfica..."
        mkdir "$out/bin"

        makeWrapper "$ICAInstDir/wfica" "$out/bin/wfica" \
          --add-flags "-icaroot $ICAInstDir" \
          --set ICAROOT "$ICAInstDir" \
          --set GTK_PATH "${gtk2.out}/lib/gtk-2.0:${gnome3.gnome-themes-standard}/lib/gtk-2.0" \
          --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
          --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
          --set LD_LIBRARY_PATH "$libPath" \
          --set NIX_REDIRECTS "/usr/share/zoneinfo=${tzdata}/share/zoneinfo:/etc/zoneinfo=${tzdata}/share/zoneinfo:/etc/timezone=$ICAInstDir/timezone"

        echo "We arbitrarily set the timezone to UTC. No known consequences at this point."
        echo UTC > "$ICAInstDir/timezone"

        echo "Installing desktop item..."
        mkdir -p $out/share/applications
        cp ${desktopItem}/share/applications/* $out/share/applications

        # We introduce a dependency on the source file so that it need not be redownloaded everytime
        echo $src >> "$out/share/nix_dependencies.pin"
      '';

      meta = with stdenv.lib; {
        license     = stdenv.lib.licenses.unfree;
        inherit homepage;
        description = "Citrix Receiver";
        maintainers = with maintainers; [ obadz a1russell ];
        platforms   = platforms.linux;
      };
    };

in citrixReceiverForVersion (lib.getAttr version versionInfo)
