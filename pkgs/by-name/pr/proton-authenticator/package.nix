{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  wrapGAppsHook4,
  webkitgtk_4_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proton-authenticator";
  version = "1.0.0";

  src = fetchurl {
    url = "https://proton.me/download/authenticator/linux/ProtonAuthenticator_${finalAttrs.version}_amd64.deb";
    hash = "sha256-Ri6U7tuQa5nde4vjagQKffWgGXbZtANNmeph1X6PFuM=";
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

    mkdir -p $out/{bin,share}
    cp usr/bin/proton-authenticator $out/bin
    cp -r usr/share/ $out/share

    runHook postInstall
  '';

  meta = {
    description = "Two-factor authentication manager with optional sync";
    homepage = "https://proton.me/authenticator";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ felschr ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "proton-authenticator";
  };
})
