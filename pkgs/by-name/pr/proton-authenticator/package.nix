{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  glib-networking,
  wrapGAppsHook4,
  webkitgtk_4_1,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-authenticator";
  version = "1.1.4";

  src = fetchurl {
    url = "https://proton.me/download/authenticator/linux/ProtonAuthenticator_${finalAttrs.version}_amd64.deb";
    hash = "sha256-SoTeqnYDMgCoWLGaQZXaHiRKGreFn7FPSz5C0O88uWM=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook4
  ];

  buildInputs = [
    webkitgtk_4_1
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 usr/bin/proton-authenticator $out/bin/${finalAttrs.meta.mainProgram}
    cp -r usr/share $out

    wrapProgram "$out/bin/${finalAttrs.meta.mainProgram}" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"

    runHook postInstall
  '';

  meta = {
    description = "Two-factor authentication manager with optional sync";
    homepage = "https://proton.me/authenticator";
    license = lib.licenses.unfree; # source not yet published
    maintainers = with lib.maintainers; [ felschr ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "proton-authenticator";
  };
})
