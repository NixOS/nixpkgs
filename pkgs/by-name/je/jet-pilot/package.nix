{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 rec {
  pname = "jet-pilot";
  version = "2.3.1";

  src = fetchurl {
    url = "https://github.com/unxsist/jet-pilot/releases/download/v${version}/JET.Pilot_${version}_amd64.AppImage";
    hash = "sha256-LK1oxxlM/5j95pHyxIRXsM5LDxC2mSUdrfGhp85aw08=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };

  meta = {
    description = "Open-source Kubernetes desktop client that focuses on less clutter, speed and good looks";
    homepage = "https://jet-pilot.app/";
    changelog = "https://github.com/unxsist/jet-pilot/releases";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "jet-pilot";
  };
}
