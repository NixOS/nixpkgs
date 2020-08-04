{ stdenv, requireFile, makeWrapper, autoPatchelfHook, wrapGAppsHook, which, more
, file, atk, alsaLib, cairo, fontconfig, gdk-pixbuf, glib, gnome3, gtk2-x11, gtk3
, heimdal, krb5, libsoup, libvorbis, speex, openssl, zlib, xorg, pango, gtk2
, gnome2, nss, nspr, gtk_engines, freetype, dconf, libpng12, libxml2
, libjpeg, libredirect, tzdata, cacert, systemd, libcxxabi, libcxx, e2fsprogs, symlinkJoin

, homepage, version, prefix, hash

, extraCerts ? []
}:

let
  inherit (stdenv) lib;

  openssl' = symlinkJoin {
    name = "openssl-backwards-compat";
    nativeBuildInputs = [ makeWrapper ];
    paths = [ openssl.out ];
    postBuild = ''
      ln -sf $out/lib/libcrypto.so $out/lib/libcrypto.so.1.0.0
      ln -sf $out/lib/libssl.so $out/lib/libssl.so.1.0.0
    '';
  };
in

stdenv.mkDerivation rec {
  pname = "citrix-workspace";
  inherit version;

  src = requireFile rec {
    name = "${prefix}-${version}.tar.gz";
    sha256 = hash;

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
  dontConfigure = true;
  sourceRoot = ".";
  preferLocalBuild = true;
  passthru.icaroot = "${placeholder "out"}/opt/citrix-icaclient";

  nativeBuildInputs = [
    autoPatchelfHook
    file
    makeWrapper
    more
    which
    wrapGAppsHook
  ];

  buildInputs = [
    alsaLib
    atk
    cairo
    dconf
    fontconfig
    freetype
    gdk-pixbuf
    gnome2.gtkglext
    gnome3.webkitgtk
    gtk2
    gtk2-x11
    gtk3
    gtk_engines
    heimdal
    krb5
    libcxx
    libcxxabi
    libjpeg
    libpng12
    libsoup
    libvorbis
    libxml2
    nspr
    nss
    openssl'
    pango
    speex
    systemd.lib
    stdenv.cc.cc
    xorg.libXaw
    xorg.libXmu
    xorg.libXScrnSaver
    xorg.libXtst
    zlib
  ] ++ lib.optional (lib.versionOlder version "20.04") e2fsprogs;

  runtimeDependencies = [
    glib

    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXext
    xorg.libXfixes
    xorg.libXinerama
    xorg.libXmu
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
  ];

  installPhase = let
    icaFlag = program:
      if (builtins.match "selfservice(.*)" program) != null then "--icaroot"
      else "-icaroot";
    wrap = program: ''
      wrapProgram $out/opt/citrix-icaclient/${program} \
        --add-flags "${icaFlag program} $ICAInstDir" \
        --set ICAROOT "$ICAInstDir" \
        --prefix LD_LIBRARY_PATH : "$ICAInstDir:$ICAInstDir/lib" \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set NIX_REDIRECTS "/usr/share/zoneinfo=${tzdata}/share/zoneinfo:/etc/zoneinfo=${tzdata}/share/zoneinfo:/etc/timezone=$ICAInstDir/timezone"
    '';
    wrapLink = program: ''
      ${wrap program}
      ln -sf $out/opt/citrix-icaclient/${program} $out/bin/${baseNameOf program}
    '';

    copyCert = path: ''
      cp -v ${path} $out/opt/citrix-icaclient/keystore/cacerts/${baseNameOf path}
    '';

    mkWrappers = lib.concatMapStringsSep "\n";

    toWrap = [ "wfica" "selfservice" "util/configmgr" "util/conncenter" "util/ctx_rehash" ]
      ++ lib.optional (lib.versionOlder version "20.06") "selfservice_old";
  in ''
    runHook preInstall

    mkdir -p $out/{bin,share/applications}
    export ICAInstDir="$out/opt/citrix-icaclient"
    export HOME=$(mktemp -d)

    # Run upstream installer in the store-path.
    sed -i -e 's,^ANSWER="",ANSWER="$INSTALLER_YES",g' -e 's,/bin/true,true,g' ./linuxx64/hinst
    ${stdenv.shell} linuxx64/hinst CDROM "$(pwd)"

    ${mkWrappers wrapLink toWrap}
    ${mkWrappers wrap [ "PrimaryAuthManager" "ServiceRecord" "AuthManagerDaemon" "util/ctxwebhelper" ]}

    ln -sf $ICAInstDir/util/storebrowse $out/bin/storebrowse

    # As explained in https://wiki.archlinux.org/index.php/Citrix#Security_Certificates
    echo "Expanding certificates..."
    pushd "$ICAInstDir/keystore/cacerts"
    awk 'BEGIN {c=0;} /BEGIN CERT/{c++} { print > "cert." c ".pem"}' \
      < ${cacert}/etc/ssl/certs/ca-bundle.crt
    popd

    ${mkWrappers copyCert extraCerts}

    # See https://developer-docs.citrix.com/projects/workspace-app-for-linux-oem-guide/en/latest/reference-information/#library-files
    # Those files are fallbacks to support older libwekit.so and libjpeg.so
    rm $out/opt/citrix-icaclient/lib/ctxjpeg_fb_8.so
    rm $out/opt/citrix-icaclient/lib/UIDialogLibWebKit.so

    # We support only Gstreamer 1.0
    rm $ICAInstDir/util/{gst_aud_{play,read},gst_*0.10,libgstflatstm0.10.so}
    ln -sf $ICAInstDir/util/gst_play1.0 $ICAInstDir/util/gst_play
    ln -sf $ICAInstDir/util/gst_read1.0 $ICAInstDir/util/gst_read

    echo "We arbitrarily set the timezone to UTC. No known consequences at this point."
    echo UTC > "$ICAInstDir/timezone"

    echo "Copy .desktop files."
    cp $out/opt/citrix-icaclient/desktop/* $out/share/applications/

    # We introduce a dependency on the source file so that it need not be redownloaded everytime
    echo $src >> "$out/share/workspace_dependencies.pin"

    runHook postInstall
  '';

  # Make sure that `autoPatchelfHook` is executed before
  # running `ctx_rehash`.
  dontAutoPatchelf = true;
  postFixup = ''
    autoPatchelf -- "$out"
    $out/opt/citrix-icaclient/util/ctx_rehash
  '';

  meta = with lib; {
    license = licenses.unfree;
    description = "Citrix Workspace";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
    inherit homepage;
  };
}
