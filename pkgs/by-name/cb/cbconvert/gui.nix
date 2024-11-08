{
  buildGoModule,
  cbconvert,
  gtk3,
  wrapGAppsHook3,
}:

buildGoModule rec {
  pname = "cbconvert-gui";

  inherit (cbconvert)
    patches
    proxyVendor
    src
    tags
    version
    ;

  nativeBuildInputs = cbconvert.nativeBuildInputs ++ [
    wrapGAppsHook3
  ];
  buildInputs = cbconvert.buildInputs ++ [ gtk3 ];

  vendorHash = "sha256-vvCvKecPszhNCQdgm3mQMb5+486BGZ9sz3R0b70eLeQ=";
  modRoot = "cmd/cbconvert-gui";

  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${version}"
  ];

  postInstall = ''
    install -D --mode=0644 --target-directory=$out/share/applications/ dist/linux/cbconvert.desktop
    install -D --mode=0644 --target-directory=$out/icons/hicolor/256x256/apps dist/linux/cbconvert.png
    install -D --mode=0644 --target-directory=$out/share/thumbnailers dist/linux/cbconvert.thumbnailer
    install -D --mode=0644 dist/linux/flatpak/io.github.gen2brain.cbconvert.metainfo.xml $out/share/metainfo/cbconvert.metainfo.xml
  '';

  postFixup = ''
    substituteInPlace $out/share/metainfo/cbconvert.metainfo.xml \
      --replace-fail "io.github.gen2brain.cbconvert" "cbconvert"
  '';

  meta = cbconvert.meta // {
    mainProgram = "cbconvert-gui";
  };
}
