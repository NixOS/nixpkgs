{ stdenv
, lib
, fetchurl
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
, xorg
, libpng12
, freetype
, fontconfig
, gtk_engines
, alsaLib
, libidn
, zlib
, version ? "19.3.0"
}:

let
  # In 56e1bdc7f9c (libidn: 1.34 -> 1.35), libidn.so.11 became libidn.so.12.
  # Citrix looks for the former so we build version 1.34 to please the binary
  libidn_134 = libidn.overrideDerivation (_: rec {
    name = "libidn-1.34";
    src = fetchurl {
      url = "mirror://gnu/libidn/${name}.tar.gz";
      sha256 = "0g3fzypp0xjcgr90c5cyj57apx1cmy0c6y9lvw2qdcigbyby469p";
    };
  });

  versionInfo = let
    supportedVersions = {
      "19.3.0" = {
        major     = "19";
        minor     = "3";
        patch     = "0";
        x64hash   = "0mhpp29ca3dw9hx72i0qawdq35wcc7qzgxwzlx4aicwnm1gbil5c";
        x86hash   = "1hxgj5lk5ghbpssbqjd404qr84gls967vwrh8ww5hg3pn86kyf8w";
        x64suffix = "5";
        x86suffix = "5";
        homepage  = https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html;
      };
    };

    # Copied this file largely from the citrix-receiver package
    # Leaving this here even though there are no deprecations yet
    # for ease of future maintenance
    deprecatedVersions = let
      versions = [ ];
    in
      lib.listToAttrs
        (lib.flip map versions
          (v: lib.nameValuePair v (throw "Unsupported citrix_workspace version: ${v}")));
  in
    deprecatedVersions // supportedVersions;

  citrixWorkspaceForVersion = { major, minor, patch, x64hash, x86hash, x64suffix, x86suffix, homepage }:
    stdenv.mkDerivation rec {
      name     = "citrix-workspace-${version}";
      version  = "${major}.${minor}.${patch}";
      inherit homepage;

      prefixWithBitness = if stdenv.is64bit then "linuxx64" else "linuxx86";

      src = requireFile rec {
        name    = if stdenv.is64bit then "${prefixWithBitness}-${version}.${x64suffix}.tar.gz" else "${prefixWithBitness}-${version}.${x86suffix}.tar.gz";
        sha256  = if stdenv.is64bit then x64hash else x86hash;
        message = ''
          In order to use Citrix Workspace, you need to comply with the Citrix EULA and download
          the ${if stdenv.is64bit then "64-bit" else "32-bit"} binaries, .tar.gz from:

          ${homepage}

          (if you do not find version ${version} there, try at
          https://www.citrix.com/downloads/workspace-app/

          Once you have downloaded the file, please use the following command and re-run the
          installation:

          nix-prefetch-url file://\$PWD/${name}
        '';
      };

      dontBuild = true;

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
        xorg.libX11
        xorg.libXext
        xorg.libXrender
        xorg.libXinerama
        xorg.libXfixes
        libpng12
        libidn_134
        zlib
        gtk_engines
        freetype
        fontconfig
        alsaLib
        stdenv.cc.cc # Fixes: Can not load [..]/opt/citrix-icaclient/lib/ctxh264_fb.so:(null)
      ];

      desktopItem = makeDesktopItem {
        name        = "wfica";
        desktopName = "Citrix Workspace";
        genericName = "Citrix Workspace";
        exec        = "wfica";
        icon        = "wfica";
        comment     = "Connect to remote Citrix server";
        categories  = "GTK;GNOME;X-GNOME-NetworkSettings;Network;";
        mimeType    = "application/x-ica";
      };

      installPhase = ''
        runHook preInstall

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
          grep -vi '\(.dll\|.so\)$' | # added as a workaround to https://github.com/NixOS/nixpkgs/issues/41729
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
          --set GTK_PATH "${gtk2.out}/lib/gtk-2.0:${gnome3.gnome-themes-extra}/lib/gtk-2.0" \
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
        echo $src >> "$out/share/workspace_dependencies.pin"

        runHook postInstall
      '';

      meta = with stdenv.lib; {
        license     = stdenv.lib.licenses.unfree;
        inherit homepage;
        description = "Citrix Workspace";
        platforms   = platforms.linux;
      };
    };

in citrixWorkspaceForVersion (lib.getAttr version versionInfo)
