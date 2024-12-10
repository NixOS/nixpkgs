{
  fetchFromGitHub,
  lib,
  buildNpmPackage,
  electron,
  nodejs,
  makeDesktopItem,
  copyDesktopItems,
  icoutils,
}:

buildNpmPackage rec {
  pname = "antares";
  version = "0.7.29";

  src = fetchFromGitHub {
    owner = "antares-sql";
    repo = "antares";
    rev = "refs/tags/v${version}";
    hash = "sha256-3zgr3Eefx3WDUW9/1NOaneUbFy3GTnJ3tGgivtW1K/g=";
  };

  npmDepsHash = "sha256-WJ5HVVa4rEOsvr52L/OGk+vlxRiKLJTxWmUnpN1FnbY=";

  patches = [
    # Since version 0.7.28, package-lock is not updated properly so this patch update it to be able to build the package
    # This patch will probably be removed in the next version
    # If it does not build without it, you just need to do a npm update in the antares project and copy the patch
    ./npm-lock.patch
  ];

  buildInputs = [ nodejs ];

  nativeBuildInputs = [
    copyDesktopItems
    icoutils
  ];

  npmBuildScript = "compile";

  installPhase = ''
    runHook preInstall
    npmInstallHook
    cp -rf dist/* $out/lib/node_modules/antares
    find -name "*.ts" | xargs rm -f
    makeWrapper ${lib.getExe electron} $out/bin/antares \
      --add-flags $out/lib/node_modules/antares/main.js
    runHook postInstall

    # Install icon files
    mkdir -pv $out/share/icon/
    icotool -x assets/icon.ico
    cp icon_1_256x256x32.png $out/share/icon/antares.png
  '';

  npmFlags = [ "--legacy-peer-deps" ];
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Antares SQL";
      exec = pname;
      icon = pname;
      terminal = false;
      type = "Application";
      startupWMClass = pname;
      comment = "A modern, fast and productivity driven SQL client with a focus in UX";
      categories = [ "Development" ];
    })
  ];

  meta = {
    description = "Modern, fast and productivity driven SQL client with a focus in UX";
    homepage = "https://github.com/antares-sql/antares";
    changelog = "https://github.com/antares-sql/antares/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eymeric ];
  };
}
