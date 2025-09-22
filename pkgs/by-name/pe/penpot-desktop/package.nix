{
  lib,
  buildNpmPackage,
  copyDesktopItems,
  electron,
  fetchFromGitHub,
  jq,
  makeDesktopItem,
  makeWrapper,
  nodejs_24,
  stdenv,
}:

let
  description = "Unofficial desktop application for the open-source design tool, Penpot";
  icon = "penpot";
  nodejs = nodejs_24;
in
buildNpmPackage rec {
  pname = "penpot-desktop";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "author-more";
    repo = "penpot-desktop";
    tag = "v${version}";
    hash = "sha256-MxkdGifPaakhX/tLHiD7Y6xCe3cZ7ELiAhD7GSmdtvk=";
  };

  makeCacheWritable = true;
  npmFlags = [
    "--engine-strict"
    "--legacy-peer-deps"
  ];
  npmDepsHash = "sha256-zOoED2WKfiDgfWQDgRrr7Gf09GbSFK+8rOsNr8VQpgY=";
  # Do not run the default build script as it leads to errors caused by the electron-builder configuration
  dontNpmBuild = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    jq
    nodejs
    makeWrapper
    copyDesktopItems
  ];

  preBuild = ''
    if [[ $(jq --raw-output '.devDependencies.electron' < package.json | grep -E --only-matching '\^[0-9]+' | sed -e 's/\^//') != ${lib.escapeShellArg (lib.versions.major electron.version)} ]]; then
      echo 'ERROR: electron version mismatch'
      exit 1
    fi
  '';

  postBuild = ''
    npm exec electron-builder -- \
      --dir \
      --c.electronDist=${electron.dist} \
      --c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out

    pushd dist/linux-${lib.optionalString stdenv.hostPlatform.isAarch64 "arm64-"}unpacked
    mkdir -p $out/opt/Penpot
    cp -r locales resources{,.pak} $out/opt/Penpot
    popd

    makeWrapper '${lib.getExe electron}' "$out/bin/penpot-desktop" \
      --add-flags $out/opt/Penpot/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    pushd build
    dir=$out/share/icons/hicolor/512x512/apps
    mkdir -p "$dir"
    cp icon.png "$dir"/${icon}.png
    popd

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Penpot";
      exec = "penpot-desktop %U";
      inherit icon;
      comment = description;
      desktopName = "Penpot";
      categories = [ "Graphics" ];
    })
  ];

  meta = {
    changelog = "https://github.com/author-more/penpot-desktop/releases/tag/v${version}";
    inherit description;
    homepage = "https://github.com/author-more/penpot-desktop";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ntbbloodbath ];
    platforms = electron.meta.platforms;
    badPlatforms = lib.platforms.darwin;
    mainProgram = "penpot-desktop";
  };
}
