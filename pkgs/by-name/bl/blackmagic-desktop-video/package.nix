{
  autoPatchelfHook,
  cacert,
  common-updater-scripts,
  curl,
  gcc,
  jq,
  lib,
  libGL,
  libcxx,
  runCommandLocal,
  stdenv,
  writeShellApplication,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "blackmagic-desktop-video";
  version = "15.3";

  buildInputs = [
    autoPatchelfHook
    libcxx
    libGL
    gcc.cc.lib
  ];

  # yes, the below download function is an absolute mess.
  # blame blackmagicdesign.
  src =
    runCommandLocal "${finalAttrs.pname}-${lib.versions.majorMinor finalAttrs.version}-src.tar.gz"
      {
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "sha256-QcM/FTEYkG1Zteb2TNysQjP/mNS1B2Wa8rqkJ70m24s=";

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
    mkdir -p $out/{bin,share/doc,lib/systemd/system}
    cp -r $unpacked/usr/share/doc/desktopvideo $out/share/doc
    cp $unpacked/usr/lib/*.so $out/lib
    cp $unpacked/usr/lib/systemd/system/DesktopVideoHelper.service $out/lib/systemd/system
    cp $unpacked/usr/lib/blackmagic/DesktopVideo/DesktopVideoHelper $out/bin/
    substituteInPlace $out/lib/systemd/system/DesktopVideoHelper.service \
      --replace-fail "/usr/lib/blackmagic/DesktopVideo/DesktopVideoHelper" "$out/bin/DesktopVideoHelper"
    runHook postInstall
  '';

  # need to tell the DesktopVideoHelper where to find its own library
  appendRunpaths = [ "${placeholder "out"}/lib" ];

  meta = with lib; {
    homepage = "https://www.blackmagicdesign.com/support/family/capture-and-playback";
    maintainers = [ maintainers.naxdy ];
    license = licenses.unfree;
    description = "Supporting applications for Blackmagic Decklink. Doesn't include the desktop applications, only the helper required to make the driver work";
    platforms = platforms.linux;
  };
})
