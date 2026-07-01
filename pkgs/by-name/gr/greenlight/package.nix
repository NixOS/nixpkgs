{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  nspr,
  nss,
  mesa,
  libglvnd,
  alsa-lib,
  libpulseaudio,
  flac,
  libxslt,
  yq,
  atk,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  gtk3,
  pango,
  libjpeg_original,
  libxkbcommon,
  unzip,
  electron_42,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "greenlight";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "unknownskl";
    repo = "greenlight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vrQtwziP+MkBseHtqego2y31UjWCJRtyf+UD35H+iSU=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-ExLu7Psd1MMLyVEr3I7BQFVo0uggv+bw1KLYF50CzXk=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
    yq
    unzip
    makeWrapper
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    nspr
    nss
    mesa
    libglvnd
    alsa-lib
    libpulseaudio
    flac
    libxslt
    stdenv.cc.cc.lib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    gtk3
    pango
    libjpeg_original
    libxkbcommon
  ];

  postPatch = ''
    [ ... ]
    cp -r ${electron_42.dist} electron-dist
    chmod -R u+w electron-dist
    yq -i -y ".electronDist = \"$PWD/electron-dist\" |
         del(.linux.target) |
         .linux.target = [\"dir\"]" $PWD/packages/desktop/electron-builder.yml
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline desktop build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/greenlight $out/bin

    cp -r packages/desktop/dist/linux-unpacked/* $out/lib/greenlight/

    makeWrapper $out/lib/greenlight/greenlight-desktop $out/bin/greenlight \
      --add-flags "--no-sandbox" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --inherit-argv0

    runHook postInstall
  '';

  postInstall = ''
    install -Dm644 packages/desktop/flatpak/io.github.unknownskl.greenlight.png \
      $out/share/icons/hicolor/512x512/apps/greenlight.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "greenlight";
      exec = "greenlight %U";
      icon = "greenlight";
      desktopName = "Greenlight";
      genericName = "Desktop client for Greenlight-Desktop";
      comment = finalAttrs.meta.description;
      categories = [
        "Game"
        "Utility"
      ];
      startupWMClass = "Greenlight";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source client for xCloud and Xbox home streaming made in Typescript";
    homepage = "https://github.com/unknownskl/greenlight";
    downloadPage = "https://github.com/unknownskl/greenlight/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ duckysocks22 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "greenlight";
  };
})
