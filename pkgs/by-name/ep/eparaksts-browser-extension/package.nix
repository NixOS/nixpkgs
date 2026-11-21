{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  pcsclite,
  qt5,
  eparaksts-middleware,
  desktop-file-utils,
  buildFHSEnv,
}:

let
  version = "2.3.9";
  name = "eparaksts-browser-extension";
  jsonname = "lv.eparaksts.eparaksts_chrome_extension.json";
  eparaksts-browser-extension = stdenv.mkDerivation (finalAttrs: {

    inherit name version;
    src = fetchurl {
      url = "https://www.eparaksts.lv/files/ep3updates/debian/pool/eparaksts/e/eparaksts-token-signing/eparaksts-token-signing_${version}_amd64.deb";
      hash = "sha256-wYpnNGUVkdDWhf4XRY1j6TABs5L8TJE/CognebXtNZQ=";
    };

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
      qt5.wrapQtAppsHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      desktop-file-utils
    ];

    buildInputs = [
      pcsclite
      qt5.qtbase
    ];

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    installPhase = ''
      runHook preInstall

      jsonpath=usr/share/eparaksts-chrome-extension
      mkdir -p $out/bin $out/lib $out/share/applications $out/etc

      cp -r usr/bin/* $out/bin
      cp -r usr/share/applications/* $out/share/applications
      cp --parents $jsonpath/eparaksts-chrome-extension.xpm $out/

      cp -r usr/lib/* $out/lib

      # chrom(ium) native messaging host jsons.
      echo "Copying $jsonpath/${jsonname}"
      cp --parents $jsonpath/${jsonname} \
        $out/

      ln -s $out/$jsonpath/eparaksts-chrome-extension.xpm $out/usr/share
      mkdir -p $out/etc/chromium/native-messaging-hosts $out/etc/chromium-browser/native-messaging-hosts
      cp $out/usr/share/eparaksts-chrome-extension/${jsonname} $out/etc/chromium/native-messaging-hosts/${jsonname}
      cp $out/usr/share/eparaksts-chrome-extension/${jsonname} $out/etc/chromium-browser/native-messaging-hosts/${jsonname}

      desktop-file-edit \
          --set-key="Icon" --set-value="$out/$jsonpath/eparaksts-chrome-extension.xpm" \
          --set-key="StartupWMClass" --set-value="eparaksts-chrome-extension" \
          $out/share/applications/eparaksts-chrome-extension.desktop

      runHook postInstall
    '';
  });
in
buildFHSEnv {
  inherit name version;
  targetPkgs = pkgs: [
    eparaksts-middleware
    eparaksts-browser-extension
  ];
  extraInstallCommands = ''
    mkdir -p $out/lib/mozilla $out/share/applications
    mkdir -p $out/usr/share/eparaksts-chrome-extension

    # Desktop file
    ln -s ${eparaksts-browser-extension}/share/applications/* $out/share/applications

    # Firefox json
    cp -r ${eparaksts-browser-extension}/lib/mozilla/* $out/lib/mozilla/

    # Chrome json
    cp -r ${eparaksts-browser-extension}/usr/share/eparaksts-chrome-extension/* $out/usr/share/eparaksts-chrome-extension

    # Symlinks for chromium
    mkdir -p $out/etc/chromium/native-messaging-hosts
    ln -s $out/usr/share/eparaksts-chrome-extension/${jsonname} $out/etc/chromium/native-messaging-hosts/${jsonname}

    # Replace native messaging host paths with fhs paths.
    substituteInPlace "$out/lib/mozilla/native-messaging-hosts/${jsonname}" \
      --replace-fail "/usr/bin/eparaksts-chrome-extension" "$out/bin/eparaksts-browser-extension"

    substituteInPlace "$out/usr/share/eparaksts-chrome-extension/${jsonname}" \
      --replace-fail "/usr/bin/eparaksts-chrome-extension" "$out/bin/eparaksts-browser-extension"
  '';
  runScript = "${eparaksts-browser-extension}/bin/eparaksts-chrome-extension";

  meta = {
    description = "eParaksts browser extension counterpart.";
    homepage = "https://www.eparaksts.lv";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ dshatz ];
    platforms = [ "x86_64-linux" ];
  };
}
