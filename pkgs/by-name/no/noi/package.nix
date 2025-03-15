{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "noi";
  version = "0.4.0";
  src = fetchurl {
    url = "https://github.com/lencx/Noi/releases/download/v${version}/Noi_linux_${version}.Appimage";
    hash = "sha256-ZwI1MpEoQn48zaan/GB7St6b15jtPHjwoUfD6bPkA3A=";
  };
  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cat > $out/share/applications/noi.desktop <<EOL
    [Desktop Entry]
    Version=1.5
    Type=Application
    Name=Noi
    Icon=noi
    Exec=noi %U
    X-AppImage-Name=noi
    X-AppImage-Version=${version}
    X-AppImage-Arch=x86_64
    EOL
    chmod +x $out/share/applications/noi.desktop
    install -D ${appimageContents}/usr/lib/noi/resources/icons/icon.png $out/share/icons/hicolor/256x256/apps/noi.png
  '';
  meta = {
    description = "Power Your World with AI - Explore, Extend, Empower";
    homepage = "https://noi.nofwl.com";
    maintainers = with lib.maintainers; [ darwincereska ];
    license = lib.licenses.unfree;
    mainProgram = "noi";
  };
}
