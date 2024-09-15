{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  makeWrapper,
  electron,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-pass";
  version = "1.22.1";

  src = fetchurl {
    url = "https://proton.me/download/PassDesktop/linux/x64/ProtonPass_${finalAttrs.version}.deb";
    hash = "sha256-DIA54xxJ8Nhh8wb4p13yjdenqgTgenAH4Tmbqk3IXwo=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r usr/share/ $out/
    cp -r usr/lib/proton-pass/resources/app.asar $out/share/
    runHook postInstall
  '';

  preFixup = ''
    makeWrapper ${lib.getExe electron} $out/bin/proton-pass \
      --add-flags $out/share/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  meta = {
    description = "Desktop application for Proton Pass";
    homepage = "https://proton.me/pass";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      massimogengarelli
      sebtm
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "proton-pass";
  };
})
