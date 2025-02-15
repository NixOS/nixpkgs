{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "dev-sidecar";
  version = "1.8.9";

  src = fetchurl {
    url = "https://github.com/docmirror/dev-sidecar/releases/download/v${version}/DevSidecar-${version}-node17.AppImage";
    hash = "sha256-ovV+rK4rIr9UmZ4OQzDqzwDSPr2VWMvAXn5P3cZj3Dc=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit src pname version;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/@docmirrordev-sidecar-gui.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/@docmirrordev-sidecar-gui.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=dev-sidecar'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Developer sidecar, proxy https requests to domestic accelerated channels";
    homepage = "https://github.com/docmirror/dev-sidecar";
    changelog = "https://github.com/docmirror/dev-sidecar/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "dev-sidecar";
  };
}
