{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  wrapGAppsHook3,
  wails,
  scdoc,
  installShellFiles,
  xorg,
  gtk3,
  webkitgtk,
  gsettings-desktop-schemas,
  snippetexpanderd,
  snippetexpanderx,
}:

buildGoModule rec {
  inherit (snippetexpanderd) src version;

  pname = "snippetexpandergui";

  vendorHash = "sha256-W9NkENdZRzqSAONI9QS2EI5aERK+AaPqwYwITKLwXQE=";

  proxyVendor = true;

  modRoot = "cmd/snippetexpandergui";

  nativeBuildInputs = [
    wails
    scdoc
    installShellFiles
    wrapGAppsHook3
  ];

  buildInputs = [
    xorg.libX11
    gtk3
    webkitgtk
    snippetexpanderd
    snippetexpanderx
  ];

  ldflags = [
    "-s"
    "-w"
    "-X 'main.version=${src.rev}'"
  ];

  tags = [
    "desktop"
    "production"
  ];

  postInstall = ''
    mv build/linux/share $out/share
    make man
    installManPage snippetexpandergui.1
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Ensure snippetexpanderd and snippetexpanderx are available to start/stop.
      --prefix PATH : ${
        lib.makeBinPath [
          snippetexpanderd
          snippetexpanderx
        ]
      }
    )
  '';

  meta = {
    description = "Your little expandable text snippet helper GUI";
    homepage = "https://snippetexpander.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ianmjones ];
    platforms = lib.platforms.linux;
    mainProgram = "snippetexpandergui";
  };
}
