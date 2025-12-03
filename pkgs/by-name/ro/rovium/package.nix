{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  wrapGAppsHook3,
  dpkg,
  alsa-lib,
  mesa,
  gtk3,
  nss,
  libxkbfile,
  libsecret,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rovium";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/rovium/rovium-beta/releases/download/v${finalAttrs.version}/rovium-${finalAttrs.version}-amd64.deb";
    hash = "sha256-6jE8z+TSMOFMbgMeVlOuzFyTOywxpMo1AIO2EiWEBFE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
    wrapGAppsHook3
    dpkg
  ];

  buildInputs = [
    alsa-lib
    mesa
    gtk3
    nss
    libxkbfile
    libsecret
  ];

  autoPatchelfIgnoreMissingDeps = [
    # Rovium binary is musl-static, libc is embedded
    "libc.musl-x86_64.so.1"
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    substituteInPlace usr/share/applications/rovium.desktop \
      --replace-fail "/opt/Rovium/rovium" "$out/bin/rovium"

    install -D --mode=644 usr/share/applications/rovium.desktop \
      --target-directory=$out/share/applications

    install -D --mode=644 usr/share/icons/hicolor/512x512/apps/rovium.png \
      --target-directory=$out/share/icons/hicolor/512x512/apps

    cp --recursive opt $out

    makeWrapper $out/opt/Rovium/rovium $out/bin/rovium \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --set ELECTRON_ENABLE_LOGGING 0 \
      --set ELECTRON_NO_UPDATER 1 \
      --set DBUS_SESSION_BUS_ADDRESS "unix:path=/run/user/\$(id -u)/bus" \
      --add-flags "--no-sandbox" \
      --add-flags "--ozone-platform=x11" \
      --add-flags "--disable-update" \
      --add-flags "--disable-component-update" \
      --add-flags "--disable-breakpad" \
      --add-flags "--disable-background-networking" \
      --add-flags "--enable-features=UseOzonePlatform"

    runHook postInstall
  '';

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Integrated Development Environment for ROS and Robotics";
    homepage = "https://rovium.dev";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ maximiliancf ];
    mainProgram = "rovium";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
