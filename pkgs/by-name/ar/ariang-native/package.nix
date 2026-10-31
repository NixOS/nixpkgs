{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  icoutils,
  makeWrapper,
  makeDesktopItem,
  electron,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "ariang-native";
  version = "1.3.15";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mayswind";
    repo = "AriaNg-Native";
    tag = finalAttrs.version;
    hash = "sha256-A+kBgsEQffiJ6bUQZePx3YRTu+WFs14gFDQixpqABXE=";
  };

  dontNpmBuild = true;
  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-gzyBs0XZ6Dhv2lhO8nx8maQ/W9R0s8XMzk+ptW/rYCE=";
  npmFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    copyDesktopItems
    icoutils
    makeWrapper
  ];

  desktopItems = with finalAttrs; [
    (makeDesktopItem {
      name = pname;
      desktopName = "AriaNg Native";
      genericName = meta.description;
      comment = meta.description;
      icon = pname;
      exec = "${pname} %U";
      mimeTypes = [ "x-scheme-handler/magnet" ];
      categories = [ "Network" ];
      startupWMClass = pname;
    })
  ];

  postInstall = with finalAttrs; ''
    # Create desktop icons
    icotool -x assets/AriaNg.ico
    ls *.png | sort -V | while read -r file; do
      size=$(echo "$file" | awk -F '_' '{print $3}' | cut -d 'x' -f 1)
      mkdir -p "$out/share/icons/hicolor/''${size}x''${size}/apps"
      mv "$file" "$out/share/icons/hicolor/''${size}x''${size}/apps/${pname}.png"
    done

    makeWrapper ${lib.getExe electron} $out/bin/${pname} \
      --inherit-argv0 \
      --add-flags "$out/lib/node_modules/${pname}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Aria2 desktop frontend based on AriaNg with additional desktop features";
    homepage = "https://github.com/mayswind/AriaNg-Native";
    changelog = "https://github.com/mayswind/AriaNg-Native/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ProxyVT ];
    mainProgram = finalAttrs.pname;
    platforms = lib.platforms.linux;
  };
})
