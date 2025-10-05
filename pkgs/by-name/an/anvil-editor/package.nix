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
  xorg,
  buildPackages,
}:

buildGoModule (finalAttrs: {
  pname = "anvil-editor";
  version = "0.6";

  # has to update vendorHash of extra package manually
  # nixpkgs-update: no auto update
  src = fetchzip {
    url = "https://anvil-editor.net/releases/anvil-src-v${finalAttrs.version}.tar.gz";
    hash = "sha256-i0S5V3j6OPpu4z1ljDKP3WYa9L+EKwo/MBNgW2ENYk8=";
  };

  modRoot = "anvil/src/anvil";

  vendorHash = "sha256-1oFBV7D7JgOt5yYAxVvC4vL4ccFv3JrNngZbo+5pzrk=";

  anvilExtras = buildGoModule {
    pname = "anvil-editor-extras";
    inherit (finalAttrs) version src meta;
    vendorHash = "sha256-4pfk5XuwDbCWFZIF+1l+dy8NfnGNjgHmSg9y6/RnTSo=";
    modRoot = "anvil-extras";
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
    xorg.libX11
    xorg.libxcb
    xorg.libXcursor
    xorg.libXfixes
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
    pushd ../../img
      # cannot add to nativeBuildInputs
      # will be conflict with icnsutils in desktopToDarwinBundle
      ${lib.getExe' buildPackages.libicns "icns2png"} -x anvil.icns
      for width in 32 48 128 256; do
        square=''${width}x''${width}
        install -Dm644 anvil_''${square}x32.png $out/share/icons/hicolor/''${square}/apps/anvil.png
      done
    popd
    cp ${finalAttrs.anvilExtras}/bin/* $out/bin
  '';

  meta = {
    description = "Graphical, multi-pane tiling editor inspired by Acme";
    homepage = "https://anvil-editor.net";
    license = lib.licenses.mit;
    mainProgram = "anvil";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = with lib.platforms; unix ++ windows;
    # Doesn't build with >buildGo123Module.
    # Multiple errors like the following:
    # '> vendor/gioui.org/internal/vk/vulkan.go:1916:9: cannot define new methods on non-local type SurfaceCapabilities'
    broken = true;
  };
})
