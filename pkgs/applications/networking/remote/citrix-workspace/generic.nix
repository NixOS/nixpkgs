{
  lib,
  stdenv,
  requireFile,
  makeWrapper,
  autoPatchelfHook,
  wrapGAppsHook3,
  alsa-lib,
  atk,
  cacert,
  cairo,
  dconf,
  enchant,
  file,
  fontconfig,
  freetype,
  fuse3,
  gdk-pixbuf,
  glib,
  glib-networking,
  gnome2,
  gst_all_1,
  gtk2,
  gtk2-x11,
  gtk3,
  gtk_engines,
  harfbuzzFull,
  heimdal,
  hyphen,
  krb5,
  lcms2,
  libGL,
  libappindicator-gtk3,
  libcanberra-gtk3,
  libcap,
  libcxx,
  libfaketime,
  libgbm,
  libinput,
  libjpeg8,
  libjson,
  libmanette,
  libnotify,
  libpng12,
  libpulseaudio,
  libredirect,
  libseccomp,
  libsecret,
  libsoup_2_4,
  libvorbis,
  libxml2_13,
  libxslt,
  llvmPackages,
  more,
  nspr,
  nss,
  opencv4,
  openssl,
  pango,
  pcsclite,
  perl,
  sane-backends,
  speex,
  symlinkJoin,
  systemd,
  tzdata,
  which,
  woff2,
  libxtst,
  libxscrnsaver,
  libxrender,
  libxmu,
  libxinerama,
  libxfixes,
  libxext,
  libxaw,
  libx11,
  xprop,
  xdpyinfo,
  libxcb,
  x264,
  zlib,

  homepage,
  version,
  hash,

  extraCerts ? [ ],
}:

let
  gstPackages = [
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-vaapi
  ];

  gstPluginPath = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" gstPackages;

  fuse3' = symlinkJoin {
    name = "fuse3-backwards-compat";
    paths = [ (lib.getLib fuse3) ];
    postBuild = ''
      ln -sf $out/lib/libfuse3.so.3.17.4 $out/lib/libfuse3.so.3
    '';
  };

  openssl' = symlinkJoin {
    name = "openssl-backwards-compat";
    nativeBuildInputs = [ makeWrapper ];
    paths = [ (lib.getLib openssl) ];
    postBuild = ''
      ln -sf $out/lib/libcrypto.so $out/lib/libcrypto.so.1.0.0
      ln -sf $out/lib/libssl.so $out/lib/libssl.so.1.0.0
    '';
  };

  opencv4' = symlinkJoin {
    name = "opencv4-compat";
    nativeBuildInputs = [ makeWrapper ];
    paths = [ opencv4 ];
    postBuild = ''
      for so in ${opencv4}/lib/*.so; do
        ln -s "$so" $out/lib/$(basename "$so").407 || true
        ln -s "$so" $out/lib/$(basename "$so").410 || true
      done
    '';
  };

in

stdenv.mkDerivation rec {
  pname = "citrix-workspace";
  inherit version;

  src = requireFile rec {
    name = "linuxx64-${version}.tar.gz";
    sha256 = hash;

    message = ''
      In order to use Citrix Workspace, you need to comply with the Citrix EULA and download
      the 64-bit binaries, .tar.gz from:

      ${homepage}

      (if you do not find version ${version} there, try at
      https://www.citrix.com/downloads/workspace-app/)

      Once you have downloaded the file, please use the following command and re-run the
      installation:

      nix-prefetch-url file://$PWD/${name}
    '';
  };

  dontBuild = true;
  dontConfigure = true;
  strictDeps = true;
  __structuredAttrs = true;
  sourceRoot = ".";
  preferLocalBuild = true;
  passthru.icaroot = "${placeholder "out"}/opt/citrix-icaclient";

  nativeBuildInputs = [
    autoPatchelfHook
    file
    libfaketime
    makeWrapper
    more
    which
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    atk
    cairo
    dconf
    enchant
    fontconfig
    freetype
    fuse3'
    gdk-pixbuf
    glib-networking
    gnome2.gtkglext
    gtk2
    gtk2-x11
    gtk3
    gtk_engines
    harfbuzzFull
    heimdal
    hyphen
    krb5
    lcms2
    libGL
    libcanberra-gtk3
    libcap
    libcxx
    libgbm
    libinput
    libjpeg8
    libjson
    libmanette
    libnotify
    libpng12
    libpulseaudio
    libseccomp
    libsecret
    libsoup_2_4
    libvorbis
    libxml2_13
    libxslt
    llvmPackages.libunwind
    nspr
    nss
    opencv4'
    openssl'
    pango
    pcsclite
    sane-backends
    speex
    stdenv.cc.cc
    (lib.getLib systemd)
    woff2
    libxscrnsaver
    libxaw
    libxmu
    libxtst
    x264
    zlib
  ]
  ++ gstPackages;

  runtimeDependencies = [
    glib
    glib-networking
    libappindicator-gtk3
    libGL
    pcsclite

    libx11
    libxscrnsaver
    libxext
    libxfixes
    libxinerama
    libxmu
    libxrender
    libxtst
    libxcb
    xdpyinfo
    xprop
  ];

  installPhase =
    let
      isSelfservice = program: (builtins.match "selfservice(.*)" program) != null;
      isWfica = program: (builtins.match "wfica(.*)" program) != null;

      icaFlag =
        program:
        if isSelfservice program then
          "--icaroot"
        else if isWfica program then
          null
        else
          "-icaroot";

      ldLibraryPath =
        program:
        lib.concatStringsSep ":" (
          lib.optional (isWfica program) "$ICAInstDir"
          ++ [
            "$ICAInstDir/lib"
            "$ICAInstDir/usr/lib/x86_64-linux-gnu"
            "$ICAInstDir/usr/lib/x86_64-linux-gnu/webkit2gtk-4.0/injected-bundle"
          ]
        );

      # Only the ICA engine needs the top-level client directory on the library
      # path. Leaving it enabled for UI helpers exposes Citrix's session-only
      # libproxy.so to the embedded web stack, which then fails to resolve CGP
      # symbols.
      wrapperArgs =
        program:
        lib.concatStringsSep " \\\n          " (
          lib.optional (icaFlag program != null) ''--add-flags "${icaFlag program} $ICAInstDir"''
          ++ [
            ''--set ICAROOT "$ICAInstDir"''
            ''--prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"''
            ''--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${gstPluginPath}"''
            ''--prefix LD_LIBRARY_PATH : "${ldLibraryPath program}"''
            ''--set LD_PRELOAD "${libredirect}/lib/libredirect.so ${lib.getLib pcsclite}/lib/libpcsclite.so"''
            ''--set NIX_REDIRECTS "/usr/share/zoneinfo=${tzdata}/share/zoneinfo:/etc/zoneinfo=${tzdata}/share/zoneinfo:/etc/timezone=$ICAInstDir/timezone:/usr/lib/x86_64-linux-gnu=$ICAInstDir/usr/lib/x86_64-linux-gnu"''
          ]
        );

      wrap = program: ''
        wrapProgram $out/opt/citrix-icaclient/${program} \
          ${wrapperArgs program}
      '';

      wrapLink = program: ''
        ${wrap program}
        ln -sf $out/opt/citrix-icaclient/${program} $out/bin/${baseNameOf program}
      '';

      makeBinWrapper = program: wrapperName: ''
        makeWrapper $out/opt/citrix-icaclient/${program} $out/bin/${wrapperName} \
          ${wrapperArgs program}
      '';

      copyCert = path: ''
        cp -v ${path} $out/opt/citrix-icaclient/keystore/cacerts/${baseNameOf path}
      '';

      mkWrappers = lib.concatMapStringsSep "\n";

      toWrap = [
        "adapter"
        "selfservice"
        "util/configmgr"
        "util/conncenter"
        "util/ctx_rehash"
      ];
    in
    ''
      runHook preInstall

      mkdir -p $out/{bin,share/applications}
      export ICAInstDir="$out/opt/citrix-icaclient"
      export HOME=$(mktemp -d)

      # Run upstream installer in the store-path.
      sed -i \
        -e 's,^ANSWER="",ANSWER="$INSTALLER_YES",g' \
        -e 's,/bin/true,true,g' \
        -e 's, -C / , -C . ,g' \
        -e 's,^[[:space:]]*install_deviceTrust "\$ICAInstDir",      :,' \
        -e 's,^[[:space:]]*install_EPA_with_prompt "\$ICAInstDir",      :,' \
        -e 's,^[[:space:]]*install_fido2Service "\$CDSourceDir" "\$ICAInstDir",  :,' \
        ./linuxx64/hinst
      source_date=$(date --utc --date=@$SOURCE_DATE_EPOCH "+%F %T")
      faketime -f "$source_date" ${stdenv.shell} linuxx64/hinst CDROM "$(pwd)"

      mkdir -p "$ICAInstDir/usr"
      tar -xzf ./linuxx64/linuxx64.cor/Webkit2gtk4.0/webkit2gtk-4.0.tar.gz \
        --strip-components=2 \
        -C "$ICAInstDir/usr" \
        webkit2gtk-4.0-package/usr/lib

      if [ -f "$ICAInstDir/util/setlog" ]; then
        chmod +x "$ICAInstDir/util/setlog"
        ln -sf "$ICAInstDir/util/setlog" "$out/bin/citrix-setlog"
      fi
      ${mkWrappers wrapLink toWrap}
      ${makeBinWrapper "wfica" "wfica"}
      ${mkWrappers wrap [
        "PrimaryAuthManager"
        "ServiceRecord"
        "AuthManagerDaemon"
        "util/ctxwebhelper"
      ]}

      ln -sf $ICAInstDir/util/storebrowse $out/bin/storebrowse

      # As explained in https://wiki.archlinux.org/index.php/Citrix#Security_Certificates
      echo "Expanding certificates..."
      pushd "$ICAInstDir/keystore/cacerts"
      awk 'BEGIN {c=0;} /BEGIN CERT/{c++} { print > "cert." c ".pem"}' \
        < ${cacert}/etc/ssl/certs/ca-bundle.crt
      popd

      ${mkWrappers copyCert extraCerts}

      # We support only Gstreamer 1.0
      rm $ICAInstDir/util/{gst_aud_{play,read},gst_*0.10,libgstflatstm0.10.so} || true
      ln -sf $ICAInstDir/util/gst_play1.0 $ICAInstDir/util/gst_play
      ln -sf $ICAInstDir/util/gst_read1.0 $ICAInstDir/util/gst_read
      # `hinst` disables multimedia when it cannot link into FHS plugin
      # directories. In Nix we provide the plugin path via wrappers instead.
      sed -i 's/^MultiMedia=Off$/MultiMedia=On/' "$ICAInstDir/config/module.ini"

      echo "We arbitrarily set the timezone to UTC. No known consequences at this point."
      echo UTC > "$ICAInstDir/timezone"

      echo "Copy .desktop files."
      cp $out/opt/citrix-icaclient/desktop/* $out/share/applications/
      for desktop in $out/share/applications/*.desktop; do
        sed -i \
          -e "s#/opt/Citrix/ICAClient#$ICAInstDir#g" \
          -e "s#$ICAInstDir/util/ctxwebhelper#ctxwebhelper#g" \
          "$desktop"

        case "$(basename "$desktop")" in
          citrixapp.desktop)
            sed -i \
              -e 's#^TryExec=.*#TryExec=selfservice#' \
              -e 's#^Exec=.*#Exec=selfservice %u#' \
              "$desktop"
            ;;
          selfservice.desktop)
            sed -i \
              -e 's#^TryExec=.*#TryExec=selfservice#' \
              -e 's#^Exec=.*#Exec=selfservice#' \
              "$desktop"
            ;;
          wfica.desktop)
            sed -i \
              -e 's#^TryExec=.*#TryExec=adapter#' \
              -e 's#^Exec=.*#Exec=adapter %f#' \
              "$desktop"
            ;;
        esac
      done

      # We introduce a dependency on the source file so that it need not be redownloaded everytime
      echo $src >> "$out/share/workspace_dependencies.pin"

      runHook postInstall
    '';

  # Make sure that `autoPatchelfHook` is executed before
  # running `ctx_rehash`.
  dontAutoPatchelf = true;
  # Null out hardcoded webkit bundle path so it falls back to LD_LIBRARY_PATH
  postFixup = ''
    ${lib.getExe perl} -0777 -pi -e 's{/usr/lib/x86_64-linux-gnu/webkit2gtk-4.0/injected-bundle/}{"\0" x length($&)}e' \
      $out/opt/citrix-icaclient/usr/lib/x86_64-linux-gnu/libwebkit2gtk-4.0.so.37.56.4

    addAutoPatchelfSearchPath --no-recurse "$out/opt/citrix-icaclient/usr/lib/x86_64-linux-gnu"
    addAutoPatchelfSearchPath "$out/opt/citrix-icaclient/usr/lib/x86_64-linux-gnu/webkit2gtk-4.0/injected-bundle"
    addAutoPatchelfSearchPath "$out/opt/citrix-icaclient/lib"
    autoPatchelf -- "$out"

    $out/opt/citrix-icaclient/util/ctx_rehash
  '';

  meta = {
    # Older versions need webkitgtk_4_0 which was removed.
    # 25.08 bundles the same.
    broken = lib.versionOlder version "25.08";
    license = lib.licenses.unfree;
    description = "Citrix Workspace";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ flacks ];
    inherit homepage;
  };
}
