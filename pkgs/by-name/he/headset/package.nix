{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  electron,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "headset";
  version = "4.2.1";

  src = fetchurl {
    url = "https://github.com/headsetapp/headset-electron/releases/download/v${finalAttrs.version}/headset_${finalAttrs.version}_amd64.deb";
    hash = "sha256-81gsIq74sggauE6g8pM6z05KTmsbe49CZa9aRQEDwMo=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    dpkg
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/headset
    cp -R usr/share/{applications,icons} $out/share
    cp -R usr/lib/headset/resources/app.asar $out/share/headset/

    makeWrapper ${electron}/bin/electron $out/bin/headset \
      --add-flags $out/share/headset/app.asar

    runHook postInstall
  '';

  meta = {
    description = "Simple music player for YouTube and Reddit";
    homepage = "https://headsetapp.co/";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ muscaln ];
    mainProgram = "headset";
  };
})
