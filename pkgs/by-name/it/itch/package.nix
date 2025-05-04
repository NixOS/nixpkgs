{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchzip,
  butler,
  replaceVars,
  runCommand,
  makeDesktopItem,

  nodejs,
  npmHooks,
  steam-run,
  electron,
  makeBinaryWrapper,
  copyDesktopItems,
  zip,

  nix-update-script,
}:
let
  itch-setup = fetchzip {
    url = "https://broth.itch.ovh/itch-setup/linux-amd64/1.27.0/itch-setup.zip";
    stripRoot = false;
    hash = "sha256-k2/+ZcToWpjAR8bTHLy13EvJvJNH81CotZ1y6+FnXFU=";
  };

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
  outDir = "artifacts/${os}-${arch.itch}";
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

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/itch

    cp -r ${outDir}/{locales,resources{,.pak}} -t $out/share/itch
    install -Dm644 ${outDir}/LICENSE -t $out/share/licenses/itch
    install -Dm644 ${outDir}/LICENSES.chromium.html -t $out/share/licenses/itch

    for icon in release/images/itch-icons/icon*.png
    do
      iconsize="''${icon#release/images/itch-icons/icon}"
      iconsize="''${iconsize%.png}"
      icondir="$out/share/icons/hicolor/''${iconsize}x''${iconsize}/apps/"
      install -Dm644 "$icon" "$icondir/itch.png"
    done

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${lib.getExe steam-run} $out/bin/itch \
      --add-flags ${lib.getExe electron} \
      --add-flags "$out/share/itch/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set BROTH_USE_LOCAL butler,itch-setup \
      --prefix PATH : ${butler}/bin:${itch-setup}
  '';

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
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = with lib.maintainers; [
      pasqui23
      pluiedev
    ];
    mainProgram = "itch";
  };
})
