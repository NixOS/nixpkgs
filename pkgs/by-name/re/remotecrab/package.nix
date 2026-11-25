{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "remotecrab";
  version = "1.4.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    name = "RemoteCrab.dmg";
    url = "https://vgoapp.com/downloads/RemoteCrab-${finalAttrs.version}.dmg";
    hash = "sha256-lR0OH/164WJBUOt/phwVhEknGwaUfzkInh/JXAJO4Xc=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "RemoteCrab.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/RemoteCrab.app"
    cp -R . "$out/Applications/RemoteCrab.app"

    runHook postInstall
  '';

  meta = {
    description = "Use an iPhone or iPad as the camera, microphone, trackpad and keyboard of a Mac";
    longDescription = ''
      Turns an iPhone or iPad into the camera, microphone, trackpad and keyboard of a
      Mac over the local network, with no account and no cloud round trip. The Mac can
      also serve itself to any browser tab with a link and a six digit code, so the
      other side installs nothing. Local network use is free; remote access from
      outside the network is a subscription.
    '';
    homepage = "https://vgoapp.com/remotecrab/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.platforms.darwin;
    maintainers = [ ];
  };
})
