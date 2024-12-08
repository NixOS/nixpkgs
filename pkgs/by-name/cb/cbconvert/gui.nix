{
  buildGoModule,
  cbconvert,
  cbconvert-gui,
  gtk3,
  pkg-config,
  testers,
  wrapGAppsHook3,
}:

buildGoModule rec {
  pname = "cbconvert-gui";

  inherit (cbconvert)
    patches
    src
    tags
    version
    ;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = cbconvert.buildInputs ++ [ gtk3 ];

  vendorHash = "sha256-oMW5zfAw2VQSVaB+Z1pE51OtNIFr+PnRMM+oBYNLWxk=";
  modRoot = "cmd/cbconvert-gui";

  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${version}"
  ];

  postInstall = ''
    install -D --mode=0644 --target-directory=$out/icons/hicolor/256x256/apps dist/linux/io.github.gen2brain.cbconvert.png
    install -D --mode=0644 --target-directory=$out/share/applications/ dist/linux/io.github.gen2brain.cbconvert.desktop
    install -D --mode=0644 --target-directory=$out/share/metainfo dist/linux/io.github.gen2brain.cbconvert.metainfo.xml
    install -D --mode=0644 --target-directory=$out/share/thumbnailers dist/linux/io.github.gen2brain.cbconvert.thumbnailer
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = cbconvert-gui;
      command = "cbconvert-gui version";
    };
  };

  meta = cbconvert.meta // {
    mainProgram = "cbconvert-gui";
  };
}
