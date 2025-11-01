{
  autoPatchelfHook,
  cacert,
  common-updater-scripts,
  curl,
  gcc,
  jq,
  lib,
  libGL,

  desktopVideoFull ? false,

  # whether to include firmware update tool
  desktopVideoUpdater ? desktopVideoFull,
  libusb1,

  # whether to include gui applications as well
  desktopVideoGUI ? desktopVideoFull,
  dbus,
  fontconfig,
  freetype,
  glib,
  libICE,
  libXrender,
  qt5,
  libcxx,
  runCommandLocal,
  stdenv,
  writeShellApplication,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blackmagic-desktop-video";
  version = "15.1";

  buildInputs = [
    autoPatchelfHook
    libcxx
    libGL
    gcc.cc.lib
  ]
  ++ lib.optionals desktopVideoUpdater [
    libusb1
  ]
  ++ lib.optionals desktopVideoGUI [
    dbus
    fontconfig
    freetype
    glib
    libICE
    libXrender
    qt5.qtbase
  ];
  nativeBuildInputs = lib.optionals desktopVideoGUI [ qt5.wrapQtAppsHook ];

  # yes, the below download function is an absolute mess.
  # blame blackmagicdesign.
  src =
    runCommandLocal "${finalAttrs.pname}-${lib.versions.majorMinor finalAttrs.version}-src.tar.gz"
      {
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "sha256-nZXfUbUyk9PDhBeXUHGt6T95hfMMDEH1oOgcm1wwi3E=";

        impureEnvVars = lib.fetchers.proxyImpureEnvVars;

        nativeBuildInputs = [
          curl
          jq
        ];

        # ENV VARS
        SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

        DOWNLOADSURL = "https://www.blackmagicdesign.com/api/support/us/downloads.json";

        USERAGENT = builtins.concatStringsSep " " [
          "User-Agent: Mozilla/5.0 (X11; Linux ${stdenv.hostPlatform.linuxArch})"
          "AppleWebKit/537.36 (KHTML, like Gecko)"
          "Chrome/77.0.3865.75"
          "Safari/537.36"
        ];

        REQJSON = builtins.toJSON {
          "country" = "nl";
          "downloadOnly" = true;
          "platform" = "Linux";
          "policy" = true;
        };

        PRODUCT = "Desktop Video";
        VERSION = finalAttrs.version;
      }
      ''
        DOWNLOADID=$(
          curl --silent --compressed "$DOWNLOADSURL" \
            | jq --raw-output '.downloads[] | .urls.Linux?[]? | select(.downloadTitle | test("^'"$PRODUCT $VERSION"'( Update)?$")) | .downloadId'
        )
        REFERID=$(
          curl --silent --compressed "$DOWNLOADSURL" \
            | jq --raw-output '.downloads[] | .urls.Linux?[]? | select(.downloadTitle | test("^'"$PRODUCT $VERSION"'( Update)?$")) | .releaseId'
        )
        echo "Download ID is $DOWNLOADID"
        echo "Refer ID is $REFERID"
        test -n "$REFERID"
        test -n "$DOWNLOADID"
        SITEURL="https://www.blackmagicdesign.com/api/register/us/download/$DOWNLOADID";
        RESOLVEURL=$(curl \
          -s \
          -H "$USERAGENT" \
          -H 'Content-Type: application/json;charset=UTF-8' \
          -H "Referer: https://www.blackmagicdesign.com/support/download/$REFERID/Linux" \
          --data-ascii "$REQJSON" \
          --compressed \
          "$SITEURL")
        curl \
          --retry 3 --retry-delay 3 \
          --compressed \
          "$RESOLVEURL" \
          > $out
      '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    # mostly stolen from pkgs/by-name/da/davinci-resolve/package.nix :)
    name = "update-blackmagic-desktop-video";
    runtimeInputs = [
      common-updater-scripts
      curl
      jq
    ];
    text = ''
      set -o errexit
      downloadsJSON="$(curl --fail --silent https://www.blackmagicdesign.com/api/support/us/downloads.json)"
      latestLinuxVersion="$(echo "$downloadsJSON" | jq '[.downloads[] | select(.urls.Linux) | .urls.Linux[] | select(.downloadTitle | test("Desktop Video")) | .downloadTitle]' | grep -oP 'Desktop Video \K\d\d\.\d+(\.\d+)?' | sort | tail -n 1)"

      update-source-version blackmagic-desktop-video "$latestLinuxVersion"
    '';
  });

  postUnpack =
    let
      arch = stdenv.hostPlatform.uname.processor;
    in
    ''
      tar xf Blackmagic_Desktop_Video_Linux_${finalAttrs.version}/other/${arch}/desktopvideo-${finalAttrs.version}*-${arch}.tar.gz
      unpacked=$NIX_BUILD_TOP/desktopvideo-${finalAttrs.version}*-${stdenv.hostPlatform.uname.processor}
    '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/doc,share/man/man1,lib/systemd/system}
    cp -r $unpacked/usr/share/doc/desktopvideo $out/share/doc
    cp $unpacked/usr/share/man/man1/DesktopVideoHelper.1 $out/share/man/man1
    cp $unpacked/usr/lib/*.so $out/lib
    cp $unpacked/usr/lib/systemd/system/DesktopVideoHelper.service $out/lib/systemd/system
    cp $unpacked/usr/lib/blackmagic/DesktopVideo/DesktopVideoHelper $out/bin/
    substituteInPlace $out/lib/systemd/system/DesktopVideoHelper.service \
      --replace-fail "/usr/lib/blackmagic/DesktopVideo/DesktopVideoHelper" "$out/bin/DesktopVideoHelper"
  ''
  + lib.optionalString desktopVideoUpdater ''
    mkdir -p $out/{opt/blackmagic/DesktopVideo/{,Firmware},share/icons,share/applications}
    cp $unpacked/usr/share/man/man1/DesktopVideo{UpdateTool,Updater}.1 $out/share/man/man1
    cp -r $unpacked/usr/share/icons/* $out/share/icons
    cp $unpacked/usr/share/applications/DesktopVideoUpdater.desktop $out/share/applications
    cp -r $unpacked/usr/lib/blackmagic/DesktopVideo/Firmware $out/opt/blackmagic/DesktopVideo/Firmware  # UpdateTool expects Firmware dir next to it
    cp $unpacked/usr/lib/blackmagic/DesktopVideo/libDVUpdate.so $out/lib
    cp $unpacked/usr/lib/blackmagic/DesktopVideo/DesktopVideo{UpdateTool,Updater} $out/opt/blackmagic/DesktopVideo
    ln -s $out/opt/blackmagic/DesktopVideo/DesktopVideo{UpdateTool,Updater} $out/bin
  ''
  + lib.optionalString desktopVideoGUI ''
    mkdir -p $out/{share/{icons,applications},opt/blackmagic/DesktopVideo/{,plugins}}
    cp -r $unpacked/usr/share/doc/desktopvideo-gui $out/share/doc
    cp $unpacked/usr/share/man/man1/BlackmagicDesktopVideoSetup.1 $out/share/man/man1
    cp -r $unpacked/usr/share/icons/* $out/share/icons
    cp $unpacked/usr/share/applications/BlackmagicDesktopVideoSetup.desktop $out/share/applications
    cp -r $unpacked/usr/lib/blackmagic/DesktopVideo/plugins $out/opt/blackmagic/DesktopVideo/plugins
    cp $unpacked/usr/lib/blackmagic/DesktopVideo/qt.conf $out/opt/blackmagic/DesktopVideo
    cp $unpacked/usr/lib/blackmagic/DesktopVideo/BlackmagicDesktopVideoSetup $out/opt/blackmagic/DesktopVideo
    ln -s $out/opt/blackmagic/DesktopVideo/BlackmagicDesktopVideoSetup $out/bin
  ''
  + ''
    runHook postInstall
  '';

  # need to tell the DesktopVideoHelper where to find its own library
  appendRunpaths = [ "${placeholder "out"}/lib" ];

  meta = with lib; {
    homepage = "https://www.blackmagicdesign.com/support/family/capture-and-playback";
    maintainers = [ maintainers.naxdy ];
    license = licenses.unfree;
    description = "Supporting applications for Blackmagic Decklink. Doesn't include the desktop applications or firmware updater by default, only the helper required to make the driver work";
    platforms = platforms.linux;
  };
})
