{
  stdenvNoCC,
  fetchurl,
  lib,
  makeWrapper,
  electron,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  writeScript,
  _7zz,
  commandLineArgs ? "",
}:
let
  icon = fetchurl {
    url = "https://obsidian.md/images/obsidian-logo-gradient.svg";
    hash = "sha256-EZsBuWyZ9zYJh0LDKfRAMTtnY70q6iLK/ggXlplDEoA=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "obsidian";
  version = "1.11.5";

  src =
    let
      filename =
        if stdenvNoCC.hostPlatform.isDarwin then
          "Obsidian-${finalAttrs.version}.dmg"
        else
          "obsidian-${finalAttrs.version}.tar.gz";
    in
    fetchurl {
      url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${finalAttrs.version}/${filename}";
      hash =
        if stdenvNoCC.hostPlatform.isDarwin then
          "sha256-5orx4Fbf7t87dPC4lHO205tnLZ5zhtpxKGOIAva9K/Q="
        else
          "sha256-j1hMEey5Z0gHkOZTGWdDQL/NKjT7S3qVu3Cpb88Zq68=";
    };

  sourceRoot = lib.optionalString stdenvNoCC.hostPlatform.isDarwin "Obsidian.app";

  strictDeps = true;
  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
    imagemagick
    copyDesktopItems
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    _7zz
  ];

  installPhase = lib.concatStringsSep "\n" [
    "runHook preInstall"
    (lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      mkdir -p $out/bin

      makeWrapper ${electron}/bin/electron $out/bin/obsidian \
        --add-flags $out/share/obsidian/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime=true --wayland-text-input-version=3}}" \
        --add-flags ${lib.escapeShellArg commandLineArgs}

      install -m 444 -D resources/app.asar $out/share/obsidian/app.asar
      install -m 444 -D resources/obsidian.asar $out/share/obsidian/obsidian.asar

      for size in 16 24 32 48 64 128 256 512; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        magick -background none ${icon} -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/obsidian.png
      done
    '')
    (lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
      mkdir -p $out/{Applications/Obsidian.app,bin}
      cp -R . $out/Applications/Obsidian.app
      makeWrapper $out/Applications/Obsidian.app/Contents/MacOS/Obsidian $out/bin/obsidian
    '')
    "runHook postInstall"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "obsidian";
      desktopName = "Obsidian";
      comment = "Knowledge base";
      icon = "obsidian";
      exec = "obsidian %u";
      categories = [ "Office" ];
      mimeTypes = [ "x-scheme-handler/obsidian" ];
    })
  ];

  passthru.updateScript = writeScript "updater" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    set -eu -o pipefail
    latestVersion="$(curl -sS https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/desktop-releases.json | jq -r '.latestVersion')"
    update-source-version obsidian "$latestVersion"
  '';

  meta = {
    description = "Powerful knowledge base that works on top of a local folder of plain text Markdown files";
    homepage = "https://obsidian.md";
    downloadPage = "https://github.com/obsidianmd/obsidian-releases/releases";
    mainProgram = "obsidian";
    license = lib.licenses.obsidian;
    maintainers = with lib.maintainers; [
      atila
      conradmearns
      zaninime
      qbit
      kashw2
      w-lfchen
    ];

    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
