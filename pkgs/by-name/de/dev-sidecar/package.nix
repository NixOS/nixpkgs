{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "dev-sidecar";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/docmirror/dev-sidecar/releases/download/v${version}/DevSidecar-${version}-linux-x86_64.AppImage";
    hash = "sha256-m/deM/qAQ3Hy2Je8SK0aJrqeuMKAwKI0OnmEH4w3QuI=";
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
    maintainers = [ lib.maintainers.linuxwhata ];
  };
}
