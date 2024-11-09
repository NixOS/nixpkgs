{
  lib,
  stdenv,
  fetchzip,
  bluez,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bluesnarfer";
  version = "0.1";

  src = fetchzip {
    url = "http://www.alighieri.org/tools/bluesnarfer.tar.gz";
    stripRoot = false;
    hash = "sha256-HGdrJZohKIsOkLETBdHz80w6vxmG25aMEWXrQlpMgRw=";
  };

  sourceRoot = finalAttrs.src.name + "/bluesnarfer";

  buildInputs = [ bluez ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bluesnarfer $out/bin/bluesnarfer
    runHook postInstall
  '';

  meta = {
    description = "Bluetooth bluesnarfing utility";
    homepage = "http://www.alighieri.org/project.html";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.linux;
  };
})
