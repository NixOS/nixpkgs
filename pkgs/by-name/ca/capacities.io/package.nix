{
  appimageTools,
  fetchurl
}:
let
  pname = "capacities.io";
  version = "1.43.47";

  src = fetchurl {
    url = "https://capacities-desktop-app.fra1.cdn.digitaloceanspaces.com/Capacities-1.43.47.AppImage";
    hash = "sha256:120w1f4hmmj2gqqd3nhznmd12hvd3cnfmjmvnq8m0a1qqpx2w7fi";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
}
