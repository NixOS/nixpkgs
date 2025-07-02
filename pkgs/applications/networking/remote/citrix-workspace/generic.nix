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
  fetchurl,
  file,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  glib-networking,
  gnome2,
  gtk2,
  gtk2-x11,
  gtk3,
  gtk_engines,
  heimdal,
  krb5,
  libGL,
  libappindicator-gtk3,
  libcanberra-gtk3,
  libcap,
  libcxx,
  libfaketime,
  libgbm,
  libinput,
  libjpeg,
  libjson,
  libpng12,
  libpulseaudio,
  libredirect,
  libsecret,
  libsoup_2_4,
  libvorbis,
  libxml2,
  llvmPackages,
  more,
  nspr,
  nss,
  opencv4,
  openssl,
  pango,
  pcsclite,
  sane-backends,
  speex,
  symlinkJoin,
  systemd,
  tzdata,
  webkitgtk_4_0,
  which,
  xorg,
  zlib,

  homepage,
  version,
  prefix,
  hash,

  extraCerts ? [ ],
}:

let
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

  libxml2' = libxml2.overrideAttrs (oldAttrs: rec {
    version = "2.13.8";
    src = fetchurl {
      url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor version}/libxml2-${version}.tar.xz";
      hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
    };
    meta = oldAttrs.meta // {
      knownVulnerabilities = oldAttrs.meta.knownVulnerabilities or [ ] ++ [
        "CVE-2025-6021"
      ];
    };
  });

in

stdenv.mkDerivation rec {
  pname = "citrix-workspace";
  inherit version;

  src = requireFile rec {
    name = "${prefix}-${version}.tar.gz";
    sha256 = hash;

    message = ''
      In order to use Citrix Workspace, you need to comply with the Citrix EULA and download
      the ${if stdenv.hostPlatform.is64bit then "64-bit" else "32-bit"} binaries, .tar.gz from:

      ${homepage}

      (if you do not find version ${version} there, try at
      https://www.citrix.com/downloads/workspace-app/)

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
    fontconfig
    freetype
    gdk-pixbuf
    glib-networking
    gnome2.gtkglext
    gtk2
    gtk2-x11
    gtk3
    gtk_engines
    heimdal
    krb5
    libGL
    libcanberra-gtk3
    libcap
    libcxx
    libgbm
    libinput
    libjpeg
    libjson
    libpng12
    libpulseaudio
    libsecret
    libsoup_2_4
    libvorbis
    libxml2'
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
    webkitgtk_4_0
    xorg.libXScrnSaver
    xorg.libXaw
    xorg.libXmu
    xorg.libXtst
    zlib
  ];

  runtimeDependencies = [
    glib
    glib-networking
    libappindicator-gtk3
    libGL
    pcsclite

    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXext
    xorg.libXfixes
    xorg.libXinerama
    xorg.libXmu
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.xdpyinfo
    xorg.xprop
  ];

  installPhase =
    let
      icaFlag =
        program:
        if (builtins.match "selfservice(.*)" program) != null then
          "--icaroot"
        else if (builtins.match "wfica(.*)" program != null) then
          null
        else
          "-icaroot";
      wrap = program: ''
        wrapProgram $out/opt/citrix-icaclient/${program} \
          ${lib.optionalString (icaFlag program != null) ''--add-flags "${icaFlag program} $ICAInstDir"''} \
          --set ICAROOT "$ICAInstDir" \
          --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
          --prefix LD_LIBRARY_PATH : "$ICAInstDir:$ICAInstDir/lib" \
          --set LD_PRELOAD "${libredirect}/lib/libredirect.so ${lib.getLib pcsclite}/lib/libpcsclite.so" \
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

      toWrap = [
        "wfica"
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
      sed -i -e 's,^ANSWER="",ANSWER="$INSTALLER_YES",g' -e 's,/bin/true,true,g' ./${prefix}/hinst
      source_date=$(date --utc --date=@$SOURCE_DATE_EPOCH "+%F %T")
      faketime -f "$source_date" ${stdenv.shell} ${prefix}/hinst CDROM "$(pwd)"

      if [ -f "$ICAInstDir/util/setlog" ]; then
        chmod +x "$ICAInstDir/util/setlog"
        ln -sf "$ICAInstDir/util/setlog" "$out/bin/citrix-setlog"
      fi
      ${mkWrappers wrapLink toWrap}
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

      # See https://developer-docs.citrix.com/en-us/citrix-workspace-app-for-linux/citrix-workspace-app-for-linux-oem-reference-guide/reference-information/#library-files
      # Those files are fallbacks to support older libwekit.so and libjpeg.so
      rm $out/opt/citrix-icaclient/lib/ctxjpeg_fb_8.so || true
      rm $out/opt/citrix-icaclient/lib/UIDialogLibWebKit.so || true

      # We support only Gstreamer 1.0
      rm $ICAInstDir/util/{gst_aud_{play,read},gst_*0.10,libgstflatstm0.10.so} || true
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
  preFixup = ''
    find $out/opt/citrix-icaclient/lib -name "libopencv_imgcodecs.so.*" | while read -r fname; do
      # lib needs libtiff.so.5, but nixpkgs provides libtiff.so.6
      patchelf --replace-needed libtiff.so.5 libtiff.so $fname
      # lib needs libjpeg.so.8, but nixpkgs provides libjpeg.so.9
      patchelf --replace-needed libjpeg.so.8 libjpeg.so $fname
    done
  '';
  postFixup = ''
    autoPatchelf -- "$out"
    $out/opt/citrix-icaclient/util/ctx_rehash
  '';

  meta = with lib; {
    license = licenses.unfree;
    description = "Citrix Workspace";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ] ++ optional (versionOlder version "24") "i686-linux";
    maintainers = with maintainers; [ flacks ];
    inherit homepage;
  };
}
