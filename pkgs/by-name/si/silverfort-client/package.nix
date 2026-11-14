{
  lib,
  stdenvNoCC,
  requireFile,
  copyDesktopItems,
  makeDesktopItem,
  wrapGAppsHook3,
  importNpmLock,
  asar,
  biome,
  dpkg,
  electron,
  nodejs,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "silverfort-client";
  version = "3.8.0";

  src = requireFile rec {
    name = "${finalAttrs.pname}_${finalAttrs.version}_amd64.deb";
    hash = "sha256-L2AZ3XXAE91cfRg3tnPhiQfv3TiuI19dD+kuDPlClSc=";
    message = ''
      Due to the commercial license of Silverfort, Nix is unable to download
      Silverfort automatically. Please download ${name} manually and add it
      to the Nix store using `nix-prefetch-url file:///$PWD/${name}`.
      It is recommended to add this file to the garbage collector root
      to prevent garbage collection.
    '';
  };

  strictDeps = true;

  nativeBuildInputs = [
    asar
    biome
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

  npmDeps = importNpmLock.buildNodeModules {
    inherit nodejs;
    package = builtins.fromJSON (builtins.readFile ./package.json);
    packageLock = builtins.fromJSON (builtins.readFile ./package-lock.json);
  };

  postPatch = ''
    asar extract "opt/Silverfort Client/resources/app.asar" $TMP/work

    # Format minified JavaScript code
    biome format --write "$TMP"/work/build/electron/main.js

    # By default, Silverfort will delete the envfile after it has been read one time.
    # This file is located at "~/.config/Silverfort Client/config.env" and can be configured
    # to store environment variables in JSON format.
    # For example: `{"SF_MESSAGING_URL":"https://example-sdms-server.net"}`
    patch -p1 -d "$TMP"/work/build/electron < ${./dont-delete-envfile.patch}

    # Patch Silverfort to work behind corporate proxies
    # by setting '$https_proxy' environment variable.
    cp -r "${finalAttrs.npmDeps}"/node_modules/* "$TMP"/work/node_modules
    patch -p1 -d "$TMP"/work/build/electron < ${./https-proxy-support.patch}
  '';

  installPhase = ''
    runHook preInstall

    # Remove unneeded files
    rm $TMP/work/build/{"public assests.zip",robots.txt}

    # Install icons
    install -Dm444 $TMP/work/build/logo192.png $out/share/icons/hicolor/192x192/apps/silverfort-client.png
    install -Dm444 $TMP/work/build/favicon.ico $out/share/icons/hicolor/256x256/apps/silverfort-client.png
    install -Dm444 $TMP/work/build/logo512.png $out/share/icons/hicolor/512x512/apps/silverfort-client.png

    asar pack $TMP/work $out/share/silverfort-client/resources/app.asar

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
