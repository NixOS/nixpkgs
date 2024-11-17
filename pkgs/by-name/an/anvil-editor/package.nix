{
  lib,
  stdenv,
  buildGoModule,
  fetchzip,
  pkg-config,
  libicns,
  copyDesktopItems,
  makeDesktopItem,
  desktopToDarwinBundle,
  apple-sdk_11,
  darwinMinVersionHook,
  wayland,
  libxkbcommon,
  vulkan-headers,
  libGL,
  xorg,
  callPackage,
  buildPackages,
  anvilExtras ? callPackage ./extras.nix { },
}:

buildGoModule rec {
  pname = "anvil-editor";
  version = "0.4";

  # has to update vendorHash of extra package manually
  # nixpkgs-update: no auto update
  src = fetchzip {
    url = "https://anvil-editor.net/releases/anvil-src-v${version}.tar.gz";
    hash = "sha256-0fi6UeppWC9KbWibjQYlPlRqsl9xsvij8YpJUS0S/wY=";
  };

  modRoot = "anvil/src/anvil";

  vendorHash = "sha256-1oFBV7D7JgOt5yYAxVvC4vL4ccFv3JrNngZbo+5pzrk=";

  nativeBuildInputs =
    [
      pkg-config
      copyDesktopItems
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      desktopToDarwinBundle
    ];

  buildInputs =
    if stdenv.hostPlatform.isDarwin then
      [
        apple-sdk_11
        # metal dependencies require 10.13 or newer
        (darwinMinVersionHook "10.13")
      ]
    else
      [
        wayland
        libxkbcommon
        vulkan-headers
        libGL
        xorg.libX11
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
      comment = meta.description;
      categories = [ "TextEditor" ];
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
    cp ${anvilExtras}/bin/* $out/bin
  '';

  passthru = {
    inherit anvilExtras;
  };

  meta = {
    description = "Graphical, multi-pane tiling editor inspired by Acme";
    homepage = "https://anvil-editor.net";
    license = lib.licenses.mit;
    mainProgram = "anvil";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = with lib.platforms; unix ++ windows;
  };
}
