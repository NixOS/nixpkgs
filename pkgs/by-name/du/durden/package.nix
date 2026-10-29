{
  lib,
  stdenvNoCC,
  fetchFromCodeberg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "durden";
  version = "0.6.3";

  src = fetchFromCodeberg {
    owner = "letoram";
    repo = "durden";
    tag = finalAttrs.version;
    hash = "sha256-dWLOLOICcVjqYTw8KAPM2/xgB9mTSEdGGIHD1WSrIvA=";
  };

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${placeholder "out"}/share/arcan/appl/
    cp -a ./durden ${placeholder "out"}/share/arcan/appl/

    runHook postInstall
  '';

  meta = {
    homepage = "https://durden.arcan-fe.com/";
    description = "Reference Desktop Environment for Arcan";
    longDescription = ''
      Durden is a desktop environment for the Arcan Display Server. It serves
      both as a reference showcase on how to take advantage of some of the
      features in Arcan, and as a very competent entry to the advanced-user side
      of the desktop environment spectrum.
    '';
    license = with lib.licenses; [ bsd3 ];
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
