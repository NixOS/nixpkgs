{
  lib,
  buildGoModule,
  wrapGAppsHook3,
  wails,
  scdoc,
  installShellFiles,
  libx11,
  gtk3,
  # webkitgtk_4_0,
  snippetexpanderd,
  snippetexpanderx,
}:

buildGoModule (finalAttrs: {
  inherit (snippetexpanderd) src version;

  pname = "snippetexpandergui";

  vendorHash = "sha256-1ofkbbitCzrLxugi769jbjOD2iN0Z6kYC5d7X2GYNIg=";

  proxyVendor = true;

  modRoot = "cmd/snippetexpandergui";

  nativeBuildInputs = [
    wails
    scdoc
    installShellFiles
    wrapGAppsHook3
  ];

  buildInputs = [
    libx11
    gtk3
    # webkitgtk_4_0
    snippetexpanderd
    snippetexpanderx
  ];

  ldflags = [
    "-s"
    "-w"
    "-X 'main.version=${finalAttrs.src.rev}'"
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
    # webkitgtk_4_0 was removed
    broken = true;
    description = "Your little expandable text snippet helper GUI";
    homepage = "https://snippetexpander.org";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "snippetexpandergui";
  };
})
