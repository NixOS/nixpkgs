{ lib
, fetchurl
, stdenvNoCC
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, unzip
, electron
, commandLineArgs ? ""
}:

stdenvNoCC.mkDerivation (finalAttrs: let
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/toeverything/AFFiNE/v${finalAttrs.version}/packages/frontend/core/public/favicon-192.png";
    hash = "sha256-smZ5W7fy3TK3bvjwV4i71j2lVmKSZcyhMhcWfPxNnN4=";
  };
in {
  pname = "affine";
  version = "0.16.0";
  src = fetchurl {
    url = "https://github.com/toeverything/AFFiNE/releases/download/v${finalAttrs.version}/affine-${finalAttrs.version}-stable-linux-x64.zip";
    hash = "sha256-6F6BzEnseqdzkEUVgUa9eu7MkyNsvucK9lGL+dsKhwc=";
  };
  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    unzip
  ];
  postInstall = ''
    mkdir -p $out/lib
    cp -r ./resources/* -t $out/lib/
    mkdir -p $out/share/doc/affine/
    cp LICENSE* $out/share/doc/affine/
    install -Dm644 ${icon} $out/share/pixmaps/affine.png
    makeWrapper "${electron}/bin/electron" $out/bin/affine \
      --inherit-argv0 \
      --add-flags $out/lib/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}
  '';
  desktopItems = [
    (makeDesktopItem {
      name = "affine";
      desktopName = "AFFiNE";
      exec = "affine %U";
      terminal = false;
      icon = "affine";
      startupWMClass = "affine";
      categories = ["Utility"];
    })
  ];
  meta = with lib; {
    description = "Workspace with fully merged docs, whiteboards and databases";
    longDescription = ''
      AFFiNE is an open-source, all-in-one workspace and an operating
      system for all the building blocks that assemble your knowledge
      base and much more -- wiki, knowledge management, presentation
      and digital assets
    '';
    homepage = "https://affine.pro/";
    downloadPage = "https://affine.pro/download";
    license = licenses.mit;
    maintainers = with maintainers; [richar redyf];
    mainProgram = "affine";
    platforms = ["x86_64-linux"];
  };
})
