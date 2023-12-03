{ lib
, fetchFromGitHub
, buildNpmPackage
, makeDesktopItem
, nix-update-script

, copyDesktopItems
, electron
, icoutils
, jq
, makeWrapper
, moreutils
}:

buildNpmPackage rec {
  pname = "chatall";
  version = "1.54.83";

  src = fetchFromGitHub {
    owner = "sunner";
    repo = "ChatAll";
    rev = "v${version}";
    hash = "sha256-TrtFSGYxiG5vsBNqtvg/vQhaEgZdFPb6I5MWjVDB988=";
  };

  npmDepsHash = "sha256-gWr2Y9ya2LSj0rZuqFOubNXQkb+zBc2dIErO1GK7Yd0=";

  nativeBuildInputs = [
    copyDesktopItems
    icoutils
    makeWrapper
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = true;
  };

  makeCacheWritable = true;

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "ChatALL";
      exec = "chatall";
      icon = "chatall";
      comment = meta.description;
      categories = [ "Utility" "Chat" ];
    })
  ];

  postPatch = ''
    ${lib.getExe jq} '.main = "dist_electron/bundled/index.js" |
      del(.dependencies."electron-builder")' \
      package.json | ${lib.getExe' moreutils "sponge"} package.json
  '';

  buildPhase = ''
    runHook preBuild

    npx vue-cli-service electron:build --dir \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/lib/chatall
    cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/lib/chatall

    mkdir -p $out/share/icons/hicolor/256x256/apps
    icotool -x -i 1 -o $out/share/icons/hicolor/256x256/apps/chatall.png src/assets/icon.ico

    makeWrapper ${lib.getExe electron} $out/bin/chatall \
      --add-flags $out/share/lib/chatall/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Chat with all AI bots concurrently, discover the best";
    homepage = "https://github.com/sunner/ChatALL";
    license = licenses.asl20;
    inherit (electron.meta) platforms;
    mainProgram = "chatall";
    maintainers = with maintainers; [ paveloom ];
  };
}
