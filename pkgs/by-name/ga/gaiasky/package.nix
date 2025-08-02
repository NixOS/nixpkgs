{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "gaiasky";
  version = "3.6.6";
  commit = "caf73d2de";

  src = fetchurl {
    url = "https://codeberg.org/gaiasky/gaiasky/releases/download/${version}/gaiasky_${version}.${commit}_x86_64.appimage";
    hash = "sha256-eq3EEONLM5Q4J/esMy4U6M9QdY08paWHHasEEO0d8xo=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/gaiasky.desktop -t $out/share/applications
    cp -r ${appimageContents}/*.png $out/share
  '';

  meta = {
    description = "Open source 3D universe visualization software for desktop and VR with support for more than a billion objects.";
    homepage = "https://gaiasky.space";
    changelog = "https://codeberg.org/gaiasky/gaiasky/releases/tag/${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ reputable2772 ];
    platforms = [ "x86_64-linux" ];
  };
}
