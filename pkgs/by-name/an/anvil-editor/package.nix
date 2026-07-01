{
  lib,
  stdenv,
  buildGoModule,
  fetchzip,
  pkg-config,
  copyDesktopItems,
  makeDesktopItem,
  desktopToDarwinBundle,
  wayland,
  libxkbcommon,
  vulkan-headers,
  libGL,
  libxfixes,
  libxcursor,
  libx11,
  libxcb,
}:

buildGoModule (finalAttrs: {
  pname = "anvil-editor";
  version = "0.7";

  # has to update vendorHash of extra package manually
  # nixpkgs-update: no auto update
  src = fetchzip {
    url = "https://anvil-editor.net/releases/anvil-src-v${finalAttrs.version}.tar.gz";
    hash = "sha256-9lJg8IMt6+GJm5a7j7ZyhbwvAmlBKvtdOv9FD9MQdrA=";
  };

  modRoot = "anvil/editor";

  vendorHash = "sha256-Q2iVB5pvP2/VXjdSwWVkdqrVUj/nIiC/VHyD5nP9ilE=";

  anvilExtras = buildGoModule {
    pname = "anvil-editor-extras";
    inherit (finalAttrs) version src meta;
    vendorHash = "sha256-Hnq1aq1DGM7IJwjU38yEk6yXmQQLyisMeaktNZNysy8=";
    modRoot = "anvil/extras";
    # Include dependency on anvil api
    postPatch = ''
      pushd anvil/extras
      cp -r ${finalAttrs.src}/anvil/api/go/anvil ./_anvil_api
      echo "replace github.com/jeffwilliams/anvil/api/go/anvil => ./_anvil_api" >> go.mod
      go mod edit -require=github.com/jeffwilliams/anvil/api/go/anvil@v0.0.0
      popd
    '';
  };

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    wayland
    libxkbcommon
    vulkan-headers
    libGL
    libx11
    libxcb
    libxcursor
    libxfixes
  ];

  # Got different result in utf8 char length?
  checkFlags = [ "-skip=^TestClearAfter$" ];

  desktopItems = [
    (makeDesktopItem {
      name = "anvil";
      exec = "anvil";
      icon = "anvil";
      desktopName = "Anvil";
      comment = finalAttrs.meta.description;
      categories = [
        "Utility"
        "TextEditor"
      ];
      startupWMClass = "anvil";
    })
  ];

  postInstall = ''
    install -Dm644 misc/icon/anvil-icon.svg $out/share/icons/hicolor/scalable/apps/anvil.svg
    cp ${finalAttrs.anvilExtras}/bin/* $out/bin
  '';

  meta = {
    description = "Graphical, multi-pane tiling editor inspired by Acme";
    homepage = "https://anvil-editor.net";
    license = lib.licenses.mit;
    mainProgram = "anvil";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = with lib.platforms; unix ++ windows;
  };
})
