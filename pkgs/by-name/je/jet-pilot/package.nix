{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 rec {
  pname = "jet-pilot";
  version = "1.28.2";

  src = fetchurl {
    url = "https://github.com/unxsist/jet-pilot/releases/download/v${version}/jet-pilot_${version}_amd64.AppImage";
    hash = "sha256-G8HsSyxZUkdOR3tW5E1/yKo3ZJ6CKTnv2RzT+fnENA0=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  meta = {
    description = "Open-source Kubernetes desktop client that focuses on less clutter, speed and good looks";
    homepage = "https://jet-pilot.app/";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "jet-pilot";
  };
}
