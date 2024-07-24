{
  lib,
  autoPatchelfHook,
  clash-meta,
  dpkg,
  fetchurl,
  libayatana-appindicator,
  nix-update-script,
  openssl,
  stdenv,
  udev,
  webkitgtk,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clash-verge-rev";
  version = "1.7.5";

  src = fetchurl {
    url = "https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v${finalAttrs.version}/clash-verge_${finalAttrs.version}_amd64.deb";
    hash = "sha256-pVEP+A4W6xLShFXuXPA6P+HZT8Hqkj/HRW2LaOOBI6U=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    openssl
    webkitgtk
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv usr/* $out

    runHook postInstall
  '';

  postFixup = ''
    rm -f $out/bin/verge-mihomo
    ln -sf ${lib.getExe clash-meta} $out/bin/verge-mihomo
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clash GUI based on tauri";
    homepage = "https://github.com/clash-verge-rev/clash-verge-rev";
    license = lib.licenses.gpl3Plus;
    mainProgram = "clash-verge";
    maintainers = with lib.maintainers; [ Guanran928 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
