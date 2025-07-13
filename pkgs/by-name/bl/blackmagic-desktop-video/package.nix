{
  stdenv,
  cacert,
  curl,
  runCommandLocal,
  lib,
  autoPatchelfHook,
  libcxx,
  libGL,
  gcc,

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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blackmagic-desktop-video";
  version = "14.4.1a4";

  buildInputs =
    [
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
  nativeBuildInputs = [ ] ++ lib.optionals desktopVideoGUI [ qt5.wrapQtAppsHook ];

  # yes, the below download function is an absolute mess.
  # blame blackmagicdesign.
  src =
    let
      # from the URL the download page where you click the "only download" button is at
      REFERID = "5baba0af3eda41ee9cd0ec7349660d74";
      # from the URL that the POST happens to, see browser console
      DOWNLOADID = "bc31044728f146859c6d9e0ccef868d8";
    in
    runCommandLocal "${finalAttrs.pname}-${lib.versions.majorMinor finalAttrs.version}-src.tar.gz"
      {
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "sha256-qh305s7u1yurv58TZnlONgDmWT4RXG3fXTfun382HAs=";

        impureEnvVars = lib.fetchers.proxyImpureEnvVars;

        nativeBuildInputs = [ curl ];

        # ENV VARS
        SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

        inherit REFERID;
        SITEURL = "https://www.blackmagicdesign.com/api/register/us/download/${DOWNLOADID}";

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
      }
      ''
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

  postUnpack =
    let
      arch = stdenv.hostPlatform.uname.processor;
    in
    ''
      tar xf Blackmagic_Desktop_Video_Linux_${lib.head (lib.splitString "a" finalAttrs.version)}/other/${arch}/desktopvideo-${finalAttrs.version}-${arch}.tar.gz
      unpacked=$NIX_BUILD_TOP/desktopvideo-${finalAttrs.version}-${stdenv.hostPlatform.uname.processor}
    '';

  installPhase =
    ''
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
      mkdir -p $out/{bin/Firmware,share/icons,share/applications}
      cp $unpacked/usr/share/man/man1/DesktopVideo{UpdateTool,Updater}.1 $out/share/man/man1
      cp -r $unpacked/usr/share/icons/* $out/share/icons
      cp $unpacked/usr/share/applications/DesktopVideoUpdater.desktop $out/share/applications
      cp -r $unpacked/usr/lib/blackmagic/DesktopVideo/Firmware $out/bin/Firmware  # UpdateTool expects Firmware dir next to it
      cp $unpacked/usr/lib/blackmagic/DesktopVideo/libDVUpdate.so $out/lib
      cp $unpacked/usr/lib/blackmagic/DesktopVideo/DesktopVideo{UpdateTool,Updater} $out/bin/
    ''
    + lib.optionalString desktopVideoGUI ''
      mkdir -p $out/{share/{icons,applications},bin/plugins}
      cp -r $unpacked/usr/share/doc/desktopvideo-gui $out/share/doc
      cp $unpacked/usr/share/man/man1/BlackmagicDesktopVideoSetup.1 $out/share/man/man1
      cp -r $unpacked/usr/share/icons/* $out/share/icons
      cp $unpacked/usr/share/applications/BlackmagicDesktopVideoSetup.desktop $out/share/applications
      cp -r $unpacked/usr/lib/blackmagic/DesktopVideo/plugins $out/bin/plugins
      cp $unpacked/usr/lib/blackmagic/DesktopVideo/qt.conf $out/bin/
      cp $unpacked/usr/lib/blackmagic/DesktopVideo/BlackmagicDesktopVideoSetup $out/bin/
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
