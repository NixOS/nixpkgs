{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  nodejs,
  yq,
  electron_43,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:
let
  electron = electron_43;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "greenlight-stream";
  version = "2.4.2-unstable-2026-11-16";

  src = fetchFromGitHub {
    owner = "unknownskl";
    repo = "greenlight";
    rev = "baa4072cbe1583e76b6271a82e8eda7d46fcf9b9";
    hash = "sha256-AkBO5Rw2ZflUJdrgya+OU4nm2s+Vo6FtMmbqy7E3oK0=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-qEw/0354YjGT6ZHL+a4dGRvSx86CPFry/oIfb3bp7so=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    yarnConfigHook
    nodejs
    yq
    makeWrapper
    copyDesktopItems
  ];

  postPatch = ''
    yq -i -y ".electronDist = \"${electron.dist}\" |
      .electronVersion = \"${electron.version}\" |
      .linux.target = [\"dir\"]" packages/desktop/electron-builder.yml
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline desktop build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 packages/desktop/dist/linux-unpacked/resources/app.asar \
      $out/share/greenlight-stream/app.asar
    install -Dm644 packages/desktop/flatpak/io.github.unknownskl.greenlight.png \
      $out/share/icons/hicolor/512x512/apps/greenlight-stream.png

    makeWrapper ${lib.getExe electron} $out/bin/greenlight-stream \
      --add-flags $out/share/greenlight-stream/app.asar \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "greenlight-stream";
      exec = "greenlight-stream %U";
      icon = "greenlight-stream";
      desktopName = "Greenlight";
      genericName = "Xbox Cloud Gaming Client";
      comment = finalAttrs.meta.description;
      categories = [
        "Game"
        "Utility"
      ];
      startupWMClass = "Greenlight";
    })
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Client for xCloud and Xbox home streaming";
    homepage = "https://github.com/unknownskl/greenlight";
    downloadPage = "https://github.com/unknownskl/greenlight/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ duckysocks22 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "greenlight-stream";
  };
})
