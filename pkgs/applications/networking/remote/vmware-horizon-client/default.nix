{ stdenv, buildFHSUserEnv, fetchurl, makeDesktopItem, libxslt, atk
, fontconfig, freetype, gdk_pixbuf, glib, gtk2, libudev0-shim, libxml2
, pango, pixman, libX11, libXext, libXinerama, libXrandr , libXrender
, libXtst, libXcursor, libXi, libxkbfile , libXScrnSaver, zlib, liberation_ttf
}:

let
    version = "4.10.0-11053294";

    vmwareBundle64 = fetchurl {
        url = https://download3.vmware.com/software/view/viewclients/CART19FQ4/VMware-Horizon-Client-4.10.0-11053294.x64.bundle;
        sha256 = "21617d8223aad7d282967b07dbf09ec5d5dd389d706063c0b791b20bdfe425bb";
    };

    vmwareBundleUnpacker = fetchurl {
        url = https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/eclass/vmware-bundle.eclass?revision=1.2;
        sha256 = "d8794c22229afdeb698dae5908b7b2b3880e075b19be38e0b296bb28f4555163";
    };

    vmwareBundle =
        if stdenv.hostPlatform.system == "x86_64-linux" then vmwareBundle64
        else throw "Unsupported system: ${stdenv.hostPlatform.system}";

    vmwareHorizonClientFiles = stdenv.mkDerivation {
        name = "vmwareHorizonClientFiles";
        inherit version;
        src = vmwareBundle;
        buildInputs = [ vmwareBundleUnpacker libxslt ];
        unpackPhase = ''
            echo '
                ebegin(){
                    echo "$1"
                }
                eend(){
                    echo OK
                }
                source "${vmwareBundleUnpacker}"
                export T="$PWD"
                vmware-bundle_extract-bundle-component "$src" vmware-horizon-client "./ext-client"
                vmware-bundle_extract-bundle-component "$src" vmware-horizon-pcoip "./ext-pcoip"
            ' >./extractor.sh
            bash ./extractor.sh # this script seems to require being run from disk
        '';
        installPhase = ''
            mkdir "$out"

            cp -a ext-client/bin "$out/"
            cp -a ext-client/lib "$out/"
            cp -a ext-client/share "$out/"
            cp -a ext-pcoip/pcoip/bin "$out/"
            cp -a ext-pcoip/pcoip/lib "$out/"

            cat <<EOF >"$out/bin/vmware-view_wrapper"
            #!/bin/sh
            export ROLLBACK_VMWAREVIEW="1"
            export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:$out/lib/vmware/view/crtbora:$out/lib/vmware"
            exec "$out/bin/vmware-view"
            EOF

            (
                find "$out" -type f | grep '\.so'
                find "$out/bin" -type f
                find "$out/lib/vmware/view/bin" -type f
            ) | xargs chmod +x
        '';
    };

    desktopItem = makeDesktopItem {
        name = "vmware-horizon-client";
        exec = "vmware-horizon-client";
        icon = "${vmwareHorizonClientFiles}/share/icons/vmware-view.png";
        desktopName = "VMware Horizon Client";
        genericName = "VMware Horizon Client";
    };

in buildFHSUserEnv {
    name = "vmware-horizon-client";
    targetPkgs = pkgs: [
        vmwareHorizonClientFiles
        atk
        fontconfig
        freetype
        gdk_pixbuf
        glib
        gtk2
        libudev0-shim
        libxml2
        pango
        pixman
        liberation_ttf
        libX11
        libXext
        libXinerama
        libXrandr
        libXrender
        libXtst
        libXcursor
        libXi
        libxkbfile
        libXScrnSaver
        zlib
    ];
    runScript = ''${vmwareHorizonClientFiles}/bin/vmware-view_wrapper'';

    extraInstallCommands = ''
        mkdir -p "$out/share/applications"
        cp "${desktopItem}"/share/applications/* $out/share/applications/
    '';

    meta = {
        license = stdenv.lib.licenses.unfree;
        homepage = https://www.vmware.com/go/viewclients;
        description = "Allows you to connect to your VMware Horizon virtual desktop";
        platforms = stdenv.lib.platforms.linux;
        maintainers = [ stdenv.lib.maintainers.buckley310 ];
    };
}
