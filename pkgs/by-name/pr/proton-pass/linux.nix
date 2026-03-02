{
  stdenvNoCC,
  dpkg,
  makeWrapper,
  electron,
  asar,
  lib,
  version,
  fetchurl,
  pname,
  meta,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version meta;

  nativeBuildInputs = [
    dpkg
    makeWrapper
    asar
  ];

  src = fetchurl {
    url = "https://proton.me/download/pass/linux/x64/proton-pass_${version}_amd64.deb";
    hash = "sha256-i5QQ1uzQ2tSDX4I/APL60QcHh9Ovc7ciueRnz7cZUuE=";
  };

  dontConfigure = true;
  dontBuild = true;

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
})
