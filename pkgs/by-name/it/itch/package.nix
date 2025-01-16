{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchzip,
  replaceVars,
  runCommand,
  makeDesktopItem,

  nodejs,
  npmHooks,
  electron,
  makeBinaryWrapper,
  copyDesktopItems,
  zip,

  nix-update-script,
}:
let
  # See release/common.js
  arches = {
    "x86_64" = {
      electron = "x64";
      itch = "amd64";
    };
    "i686" = {
      electron = "ia32";
      itch = "386";
    };
  };

  os = stdenvNoCC.hostPlatform.parsed.kernel.name;
  arch = arches.${stdenvNoCC.hostPlatform.parsed.cpu.name};

  # FIXME: build from source once possible
  butler = fetchzip {
    url = "https://broth.itch.zone/butler/${os}-${arch.itch}/15.24.0/butler.zip";
    stripRoot = false;
    hash = "sha256-/0rwqkWfvQd1p8NbjQLARILBfpwmwC6dsR2ZYje4fXs=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "itch";
  version = "26.1.9";

  src = fetchFromGitHub {
    owner = "itchio";
    repo = "itch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+fjgQDQKeHLGqVKSAgort8fJ2laAKfHkpKAKeQcte4Y=";
  };

  patches = [
    (replaceVars ./patch-build-scripts.patch {
      electronVersion = electron.version;

      # For some reason, electron-packager only allows one to skip downloading Electron
      # if and only if `electronZipDir` is set to a directory containing a zip file
      # named `electron-v${electron.version}-${os}-${arch}.zip`. I don't know why,
      # though it seems unavoidable.
      electronZipDir = runCommand "electron-zip-dir" { nativeBuildInputs = [ zip ]; } ''
        cp -r ${electron.dist} electron-dist
        (cd electron-dist; zip -0Xqr ../electron-v${electron.version}-${os}-${arch.electron}.zip *)
        install -D *.zip -t $out
      '';
    })
  ];

  npmDeps = fetchNpmDeps {
    pname = "itch-npm-deps";
    inherit (finalAttrs) version src;
    hash = "sha256-mSPoXdKogE+mX6efjW8VcKYwtiXEkKJ00YznsR9jtfs=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    copyDesktopItems
    makeBinaryWrapper
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = true;
    # For proper version identification
    CI_COMMIT_TAG = finalAttrs.src.tag;
  };

  buildPhase = ''
    runHook preBuild

    # TODO: figure out why electron-packager fails to create this itself
    mkdir -p build/${finalAttrs.src.tag}/${os}-${arch.electron}-template/{locales,resources}/

    node release/build.js --os ${os} --arch ${arch.itch}
    node release/package.js --os ${os} --arch ${arch.itch}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/itch
    cp -r artifacts/${os}-${arch.itch}/{locales,resources{,.pak}} -t $out/share/itch

    makeWrapper ${lib.getExe electron} $out/bin/itch \
      --add-flags "$out/share/itch/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set BROTH_USE_LOCAL butler \
      --prefix PATH : ${butler}

    for size in 16 32 36 48 64 72 114 128 144 150 256 512 1024; do
      install -D release/images/itch-icons/icon''${size}.png \
         $out/share/icons/hicolor/''${size}x''${size}/apps/itch.png
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "itch";
      exec = "itch %U";
      tryExec = "itch";
      icon = "itch";
      desktopName = "itch";
      mimeTypes = [
        "x-scheme-handler/itchio"
        "x-scheme-handler/itch"
      ];
      comment = "Install and play itch.io games easily";
      categories = [ "Game" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Best way to play itch.io games";
    homepage = "https://github.com/itchio/itch";
    changelog = "https://github.com/itchio/itch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    # https://itchio.itch.io/itch only provides up-to-date binaries for these platforms
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "x86_64-windows"
      "i686-windows"
    ];
    maintainers = with lib.maintainers; [
      pasqui23
      pluiedev
    ];
    mainProgram = "itch";
  };
})
