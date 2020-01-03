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
, dconf
, glib
, gtk2
, atk
, gdk-pixbuf
, cairo
, pango
, gnome3
, xorg
, libpng12
, freetype
, fontconfig
, gtk_engines
, alsaLib
, zlib
, version ? "19.12.0"
}:

let
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
        homepage  = https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-1903.html;
      };

      "19.6.0" = {
        major     = "19";
        minor     = "6";
        patch     = "0";
        x64hash   = "0szqlfmigzgf0309i6ikxkizxaf4ri7qmhys75m0zi3bpwx6hzhs";
        x86hash   = "16v3kgavrh62z6vxcbw6mn7h0bfishpl7m92k7g1p2882r1f8vaf";
        x64suffix = "60";
        x86suffix = "60";
        homepage  = https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest.html;
      };

      "19.8.0" = {
        major     = "19";
        minor     = "8";
        patch     = "0";
        x64hash   = "0f8djw8lp5wihb23y09yac1mh09w1qp422h72r6zfx9k1lqfsdbw";
        x86hash   = "0afcqirb4q349r3izy88vqkszg6y2wg14iwypk6nrmvwgvcl6jdn";
        x64suffix = "20";
        x86suffix = "20";
        homepage  = https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest1.html;
      };

      "19.10.0" = {
        major     = "19";
        minor     = "10";
        patch     = "0";
        x64hash   = "1l4q4pmfiw9gmml6j5b3hls2101xf5m8p6855nhfhvqlisrj9h14";
        x86hash   = "000zjik8wf8b6fadnsai0p77b4n2l95544zx503iyrb9pv53bj3y";
        x64suffix = "15";
        x86suffix = "15";
        homepage  = https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-1910.html;
      };

      "19.12.0" = {
        major     = "19";
        minor     = "12";
        patch     = "0";
        x64hash   = "1si5mkxbgb8m99bkvgc3l80idjfdp0kby6pv47s07nn43dbr1j7a";
        x86hash   = "07rfp90ksnvr8zv7ix7f0z6a59n48s7bd4kqbzilfwxgs4ddqmcy";
        x64suffix = "19";
        x86suffix = "19";
        homepage  = https://www.citrix.com/de-de/downloads/workspace-app/linux/workspace-app-for-linux-latest.html;
      };
    };

    # Copied this file largely from the citrix-receiver package
    # Leaving this here even though there are no deprecations yet
    # for ease of future maintenance.
    #
    # The lifespans of Citrix products can be found here:
    # https://www.citrix.com/support/product-lifecycle/milestones/receiver.html
    deprecatedVersions = let
      versions = [ ];
    in
      lib.listToAttrs
        (lib.forEach versions
          (v: lib.nameValuePair v (throw "Unsupported citrix_workspace version: ${v}")));
  in
    deprecatedVersions // supportedVersions;

  citrixWorkspaceForVersion = { major, minor, patch, x64hash, x86hash, x64suffix, x86suffix, homepage }:
    stdenv.mkDerivation rec {
      pname = "citrix-workspace";
      version  = "${major}.${minor}.${patch}";
      inherit homepage;

      prefixWithBitness = if stdenv.is64bit then "linuxx64" else "linuxx86";

      preferLocalBuild = true;

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
        gdk-pixbuf
      ];

      libPath = stdenv.lib.makeLibraryPath [
        glib
        gtk2
        atk
        gdk-pixbuf
        cairo
        pango
        dconf
        xorg.libX11
        xorg.libXext
        xorg.libXrender
        xorg.libXinerama
        xorg.libXfixes
        libpng12
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
        maintainers = with maintainers; [ ma27 ];
      };
    };

in citrixWorkspaceForVersion (lib.getAttr version versionInfo)
