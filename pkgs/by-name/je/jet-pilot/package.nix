{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 rec {
  pname = "jet-pilot";
  version = "1.37.0";

  src = fetchurl {
    url = "https://github.com/unxsist/jet-pilot/releases/download/v${version}/JET.Pilot_${version}_amd64.AppImage";
    hash = "sha256-52wNa+ctfTlokoSlzy5W5xk4r3jERzcN3e3M1P1fFuU=";
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
