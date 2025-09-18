{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  makeWrapper,
  electron,
  asar,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-pass";
  version = "1.32.6";

  src = fetchurl {
    url = "https://proton.me/download/pass/linux/x64/proton-pass_${finalAttrs.version}_amd64.deb";
    hash = "sha256-xtptEi/H15fEABrlPE854uSWagr2kt2/h33SuegVab8=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    dpkg
    makeWrapper
    asar
  ];

  # Rebuild the ASAR archive, hardcoding the resourcesPath
  preInstall = ''
    asar extract usr/lib/proton-pass/resources/app.asar tmp
    rm usr/lib/proton-pass/resources/app.asar
    substituteInPlace tmp/.webpack/main/index.js \
      --replace-fail "process.resourcesPath" "'$out/share/proton-pass'"
    asar pack tmp/ usr/lib/proton-pass/resources/app.asar
    rm -fr tmp
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/proton-pass
    cp -r usr/share/ $out/
    cp -r usr/lib/proton-pass/resources/{app.asar,assets} $out/share/proton-pass/
    runHook postInstall
  '';

  preFixup = ''
    makeWrapper ${lib.getExe electron} $out/bin/proton-pass \
      --add-flags $out/share/proton-pass/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
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
