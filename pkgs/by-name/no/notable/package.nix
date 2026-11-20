{
  appimageTools,
  makeWrapper,
  fetchurl,
  lib,
}:

appimageTools.wrapType2 (finalAttrs: {

  pname = "notable";
  version = "1.8.4";

  src = fetchurl {
    url = "https://github.com/notable/notable/releases/download/v${finalAttrs.version}/Notable-${finalAttrs.version}.AppImage";
    hash = "sha256-fuWfGYYT816M2yG3PcEAyxeYIBcW7ZsQjlOYqPlHf2c=";
  };

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  nativeBuildInputs = [ makeWrapper ];

  extraPkgs = pkgs: [
    pkgs.at-spi2-atk
    pkgs.at-spi2-core
  ];

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/notable.desktop $out/share/applications/notable.desktop
    for size in 16 32 48 64 128 256 512; do
      install -m 444 -D ${finalAttrs.contents}/usr/share/icons/hicolor/''${size}x''${size}/apps/notable.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/notable.png
    done
    install -m 444 -D ${finalAttrs.contents}/usr/share/icons/hicolor/1024x1024/apps/notable.png \
      $out/share/icons/notable.png
    substituteInPlace $out/share/applications/notable.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=notable'
    wrapProgram "$out/bin/notable" \
      --add-flags "--disable-seccomp-filter-sandbox"
  '';

  meta = {
    description = "Markdown-based note-taking app that doesn't suck";
    homepage = "https://github.com/notable/notable";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
})
