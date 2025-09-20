{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "sacnview";
  version = "2.1.3";

  src = fetchurl {
    url = "https://github.com/docsteer/sacnview/releases/download/v${version}/sACNView_${version}-x86_64.AppImage";
    hash = "sha256-9YmTYmrlGq5uJ8MWLRSEb4wtK834kURcAESH87JO4OA=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  meta = {
    description = "a tool for monitoring and sending the Streaming ACN lighting control protocol used in theatres, TV studios and architectural systems.";
    changelog = "https://github.com/docsteer/sacnview/releases/tag/${version}";
    homepage = "https://sacnview.org/";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ zax71 ];
    platforms = lib.platforms.linux;
    mainProgram = "sacnview";
  };
}
