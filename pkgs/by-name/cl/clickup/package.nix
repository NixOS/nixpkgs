{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "clickup";
  version = "3.3.79";

  src = fetchurl {
    # Using archive.org because the website doesn't store older versions of the software.
    url = "https://web.archive.org/web/20240601173958/https%3A%2F%2Fdesktop.clickup.com%2Flinux";
    hash = "sha256-jAOYDX9j+ZTqWsSg0rEckKZnErgsIV6+CtUv3M3wNqM=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.xorg.libxkbfile ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/desktop.desktop $out/share/applications/clickup.desktop

    substituteInPlace $out/share/applications/clickup.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=clickup' \
      --replace-fail 'Icon=desktop' 'Icon=clickup'

    for size in 16 32 64 128 256 512 1024; do
      install -Dm444 ${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/desktop.png \
        -t $out/share/icons/hicolor/''${size}x''${size}/apps/clickup.png
    done
  '';

  meta = {
    description = "All in one project management solution";
    homepage = "https://clickup.com";
    license = lib.licenses.unfree;
    mainProgram = "clickup";
    maintainers = with lib.maintainers; [ heisfer ];
    platforms = [ "x86_64-linux" ];
  };
}
