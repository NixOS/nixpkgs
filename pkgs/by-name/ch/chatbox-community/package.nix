{
  lib,

  fetchFromGitHub,
  buildNpmPackage,

  pkg-config,
  makeBinaryWrapper,
  makeDesktopItem,
  copyDesktopItems,

  electron,
  vips,
}:

let

  manifest = lib.importJSON ./manifest.json;

in

buildNpmPackage (finalAttrs: {
  pname = "chatbox-community";
  inherit (manifest) version;

  src = fetchFromGitHub {
    owner = "chatboxai";
    repo = "chatbox";
    inherit (manifest) rev hash;
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    electron
    vips
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    # Silence the error when electron-builder reads its configuration.
    UPDATE_CHANNEL = "built-by-nixpkgs-and-never-published-to-the-upstream";
  };

  patches = [
    ./patches/correct-resources-path.patch
  ];

  postPatch =
    let
      packageLock = builtins.path {
        path = ./package-lock.json;
        name = "package-lock.json";
      };
    in
    ''
      cp ${packageLock} ./$(stripHash ${packageLock})
    '';
  inherit (manifest) npmDepsHash;

  preBuild = ''
    npx ts-node ./.erb/scripts/clean.js dist
  '';

  postBuild = ''
    npx electron-builder \
        --publish never \
        --dir \
        --c.electronDist=${electron.dist} \
        --c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -pr release/build/*-unpacked $out/share/chatbox

    makeWrapper ${lib.getExe electron} $out/bin/chatbox \
      --add-flags $out/share/chatbox/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    for icon in $out/share/chatbox/resources/assets/icons/*.png; do
        dst_icon=$out/share/icons/hicolor/$(basename $icon .png)/apps
        mkdir -p $dst_icon
        ln -s $icon $dst_icon/chatbox.png
    done

    runHook postInstall
  '';

  desktopItems = [
    # According to `electron-builder.yml` instead of `[release/app/]package.json`.
    (makeDesktopItem {
      name = "xyz.chatboxapp.app";
      desktopName = "Chatbox";
      genericName = "Client for Generative AI Models";
      icon = "chatbox";
      exec = finalAttrs.meta.mainProgram + " %U";
      categories = [
        "Network"
        "Science"
        "ArtificialIntelligence"
      ];
    })
  ];

  passthru.updateScript = {
    command = ./update.py;
    supportedFeatures = [
      "commit"
    ];
  };

  meta = {
    description = "User-friendly desktop client app for AI models/LLMs";
    longDescription = ''
      Chatbox AI is an AI client application and smart assistant. Compatible
      with many cutting-edge AI models and APIs.

      This is the Chatbox Community Edition, open-sourced under the GPLv3
      license.
    '';
    # Not chatboxai.app, where you can find an unfree _Terms & Conditions_.
    homepage = "https://github.com/chatboxai/chatbox";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rc-zb ];
    platforms = electron.meta.platforms;
    mainProgram = "chatbox";
  };
})
