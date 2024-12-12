{
  buildGoModule,
  cbconvert,
  gtk3,
  pkg-config,
  versionCheckHook,
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
    install -D --mode=0644 --target-directory=$out/share/icons/hicolor/256x256/apps dist/linux/io.github.gen2brain.cbconvert.png
    install -D --mode=0644 --target-directory=$out/share/applications/ dist/linux/io.github.gen2brain.cbconvert.desktop
    install -D --mode=0644 --target-directory=$out/share/metainfo dist/linux/io.github.gen2brain.cbconvert.metainfo.xml
    install -D --mode=0644 --target-directory=$out/share/thumbnailers dist/linux/io.github.gen2brain.cbconvert.thumbnailer
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = cbconvert.meta // {
    mainProgram = "cbconvert-gui";
  };
}
