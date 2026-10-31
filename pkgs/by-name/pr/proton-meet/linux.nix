{
  stdenvNoCC,
  dpkg,
  makeWrapper,
  electron,
  asar,
  lib,
  version,
  pname,
  passthru,
  meta,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version;

  src =
    finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    dpkg
    makeWrapper
    asar
  ];

  dontConfigure = true;
  dontBuild = true;

  # process.resourcesPath would point into the nixpkgs electron package, so
  # loading.html and error-network.html would not be found; point it at the
  # copy of upstream's resources/ installed below and repack the ASAR archive.
  preInstall = ''
    asar extract usr/lib/proton-meet/resources/app.asar tmp
    rm usr/lib/proton-meet/resources/app.asar
    substituteInPlace tmp/.webpack/main/index.js \
      --replace-fail "process.resourcesPath" "'$out/share/proton-meet'"
    asar pack tmp/ usr/lib/proton-meet/resources/app.asar
    rm -fr tmp
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/proton-meet
    cp -r usr/share/ $out/
    cp -r usr/lib/proton-meet/resources/* $out/share/proton-meet/
    runHook postInstall
  '';

  # ELECTRON_FORCE_IS_PACKAGED makes app.isPackaged true, which the app needs
  # for its bundled loading/error pages and its TLS certificate pinning.
  preFixup = ''
    makeWrapper ${lib.getExe electron} $out/bin/proton-meet \
      --add-flags $out/share/proton-meet/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  inherit passthru meta;
})
