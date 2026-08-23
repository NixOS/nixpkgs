{
  fetchFromGitHub,
  lib,
  buildNpmPackage,
  electron,
  nodejs_22,
  makeDesktopItem,
  copyDesktopItems,
  icoutils,
  fetchpatch2,
}:

buildNpmPackage rec {
  pname = "antares";
  version = "0.7.35";

  src = fetchFromGitHub {
    owner = "antares-sql";
    repo = "antares";
    tag = "v${version}";
    hash = "sha256-A/ievIKXfFGu90aijxhmEWvfg2RqDtd7AtU+iyma3lU=";
  };

  npmDepsHash = "sha256-X2dG75fpeXeU40wb22KAI7tDBybFwWUpKVj0Mlo3xhc=";

  patches = [
    # Since version 0.7.28, package-lock is not updated properly so this patch update it to be able to build the package
    # This patch will probably be removed in the next version
    # If it does not build without it, you just need to do a npm update in the antares project and copy the patch
    # https://github.com/antares-sql/antares/pull/1005
    (fetchpatch2 {
      url = "https://github.com/antares-sql/antares/commit/6b2a45d93cf7fefdc92e0d87f390cd21a069b9a4.patch?full_index=1";
      hash = "sha256-2dOGY0K6jMxSLNLDhwy/+ysTRB24XRXSoDu1AVxi4w4=";
    })
  ];

  nodejs = nodejs_22;

  buildInputs = [ nodejs_22 ];

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
