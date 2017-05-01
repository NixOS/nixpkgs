{ stdenv
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
}:

let versionRec = { major = "13"; minor = "4"; patch = "0"; };
in stdenv.mkDerivation rec {
  name = "citrix-receiver-${version}";
  version = with versionRec; "${major}.${minor}.${patch}";
  homepage = https://www.citrix.com/downloads/citrix-receiver/linux/receiver-for-linux-latest.html;

  prefixWithBitness = if stdenv.is64bit then "linuxx64" else "linuxx86";

  src = with versionRec; requireFile rec {
    name = "${prefixWithBitness}-${version}.10109380.tar.gz";
    sha256 =
      if stdenv.is64bit
      then "133brs0sq6d0mgr19rc6ig1n9ahm3ryi23v5nrgqfh0hgxqcrrjb"
      else "0r7jfl5yqv1s2npy8l9gsn0gbb82f6raa092ppkc8xy5pni5sh7l";
    message = ''
      In order to use Citrix Receiver, you need to comply with the Citrix EULA and download
      the ${if stdenv.is64bit then "64-bit" else "32-bit"} binaries, .tar.gz from:

      ${homepage}

      (if you do not find version ${version} there, try at
      https://www.citrix.com/downloads/citrix-receiver/legacy-receiver-for-linux/receiver-for-linux-latest-${major}-${minor}.html
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
    gtk_engines
    freetype
    fontconfig
    alsaLib
    stdenv.cc.cc # Fixes: Can not load [..]/opt/citrix-icaclient/lib/ctxh264_fb.so:(null)
  ];

  desktopItem = makeDesktopItem {
    name = "wfica";
    desktopName = "Citrix Receiver";
    genericName = "Citrix Receiver";
    exec = "wfica";
    icon = "wfica";
    comment = "Connect to remote Citrix server";
    categories = "GTK;GNOME;X-GNOME-NetworkSettings;Network;";
    mimeType = "application/x-ica";
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
    ./${prefixWithBitness}/hinst CDROM "`pwd`"

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
      --set GTK_PATH "${gtk2.out}/lib/gtk-2.0:${gnome3.gnome_themes_standard}/lib/gtk-2.0" \
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
    license = stdenv.lib.licenses.unfree;
    homepage = homepage;
    description = "Citrix Receiver";
    maintainers = with maintainers; [ obadz a1russell ];
    platforms = platforms.linux;
  };
}
