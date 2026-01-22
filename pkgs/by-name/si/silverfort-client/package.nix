{
  lib,
  stdenvNoCC,
  requireFile,
  copyDesktopItems,
  makeDesktopItem,
  wrapGAppsHook3,
  asar,
  dpkg,
  electron,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "silverfort-client";
  version = "3.7.5";

  src = requireFile rec {
    name = "${finalAttrs.pname}_${finalAttrs.version}_amd64.deb";
    hash = "sha256-eOkSVoucMiGH4sTnC8/3sWMyT9DpnGEYXX+1y2ULDBg=";
    message = ''
      Due to the commercial license of Silverfort, Nix is unable to download
      Silverfort automatically. Please download ${name} manually and add it
      to the Nix store using \`nix-prefetch-url file:///\$PWD/${name}\`.
      It is recommended to add this file to the garbage collector root
      to prevent grabage collection.
    '';
  };

  strictDeps = true;

  nativeBuildInputs = [
    asar
    copyDesktopItems
    dpkg
    wrapGAppsHook3
  ];

  # Prevent double wrapping
  dontWrapGApps = true;

  desktopItems = [
    (makeDesktopItem {
      name = "silverfort-client";
      desktopName = "Silverfort Client";
      genericName = "Multi-factor authentication client";
      comment = "Silverfort Desktop Messaging Client";
      icon = "silverfort-client";
      exec = "silverfort-client";
      categories = [
        "Utility"
        "Security"
      ];
      keywords = [
        "2fa"
        "authentication"
        "factor"
        "mfa"
        "multi"
      ];
      startupWMClass = "Silverfort Client";
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    asar extract "opt/Silverfort Client/resources/app.asar" $TMP/work

    # Remove unneeded files
    rm $TMP/work/build/{"public assests.zip",robots.txt}

    # Install icons
    install -Dm444 $TMP/work/build/logo192.png $out/share/icons/hicolor/192x192/apps/silverfort-client.png
    install -Dm444 $TMP/work/build/favicon.ico $out/share/icons/hicolor/256x256/apps/silverfort-client.png
    install -Dm444 $TMP/work/build/logo512.png $out/share/icons/hicolor/512x512/apps/silverfort-client.png

    # By default, Silverfort will delete the envfile after it has been read one time.
    # This file is located at "~/.config/Silverfort Client/config.env" and can be configured
    # to store environment variables in JSON format.
    # For example: `{"SF_MESSAGING_URL":"https://example-sdms-server.net"}`
    patch -d $TMP/work -p1 < ${./dont-delete-envfile.patch}

    asar pack $TMP/work $out/share/silverfort-client/resources/app.asar

    rm -rf $TMP/work

    runHook postInstall
  '';

  postFixup = ''
    makeBinaryWrapper "${lib.getExe electron}" $out/bin/silverfort-client \
      --add-flags "$out/share/silverfort-client/resources/app.asar" \
      --set-default ELECTRON_IS_DEV 0 \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "Silverfort multi-factor authentication client";
    homepage = "https://www.silverfort.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "silverfort-client";
  };
})
