{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  copyDesktopItems,
  icoutils,
  makeWrapper,
  makeDesktopItem,
  electron,
}:

buildNpmPackage (finalAttrs: {
  pname = "ariang-native";
  version = "1.3.14";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mayswind";
    repo = "AriaNg-Native";
    tag = finalAttrs.version;
    hash = "sha256-ByQPAZVQEqqjD7th0wq06NdOsAR7YchWpV3LHu4QzTk=";
  };

  dontNpmBuild = true;
  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-mTu/QcsPq7YoUSuKtS34P+y38oIoB3zyuDL9ELQDoBQ=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

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

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags "$out/lib/node_modules/${pname}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A better aria2 desktop frontend than AriaNg, with all features of AriaNg and providing more features for desktop usage";
    homepage = "https://github.com/mayswind/AriaNg-Native";
    changelog = "https://github.com/mayswind/AriaNg-Native/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ProxyVT ];
    mainProgram = finalAttrs.pname;
  };
})
