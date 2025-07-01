{
  lib,
  apple-sdk_14,
  buildNpmPackage,
  cargo,
  copyDesktopItems,
  darwin,
  electron_36,
  fetchFromGitHub,
  gnome-keyring,
  jq,
  llvmPackages_18,
  makeDesktopItem,
  makeWrapper,
  napi-rs-cli,
  nix-update-script,
  nodejs_20,
  pkg-config,
  rustc,
  rustPlatform,
  stdenv,
  xcbuild,
}:

let
  description = "Secure and free password manager for all of your devices";
  icon = "bitwarden";
  electron = electron_36;

  # argon2 npm dependency is using `std::basic_string<uint8_t>`, which is no longer allowed in LLVM 19
  buildNpmPackage' = buildNpmPackage.override {
    stdenv = if stdenv.hostPlatform.isDarwin then llvmPackages_18.stdenv else stdenv;
  };
in
buildNpmPackage' rec {
  pname = "bitwarden-desktop";
  version = "2025.6.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "desktop-v${version}";
    hash = "sha256-KI6oIMNtqfywVqeTdzthSHBnAlF55cINTr04LNSq0AM=";
  };

  patches = [
    ./electron-builder-package-lock.patch
    ./dont-auto-setup-biometrics.patch
    # The nixpkgs tooling trips over upstreams inconsistent lock files, so we fixed them by running npm install open@10.2.1 and cargo b
    ./fix-lock-files.diff

    # ensures `app.getPath("exe")` returns our wrapper, not ${electron}/bin/electron
    ./set-exe-path.patch
    # on linux: don't flip fuses, don't create wrapper script, on darwin: don't try copying safari extensions, don't try re-signing app
    ./skip-afterpack-and-aftersign.patch
    # since out arch doesn't match upstream, we'll generate and use desktop_napi.node instead of desktop_napi.${platform}-${arch}.node
    ./dont-use-platform-triple.patch
  ];

  postPatch = ''
    # remove code under unfree license
    rm -r bitwarden_license

    substituteInPlace apps/desktop/src/main.ts --replace-fail '%%exePath%%' "$out/bin/bitwarden"

    # force canUpdate to false
    # will open releases page instead of trying to update files
    substituteInPlace apps/desktop/src/main/updater.main.ts \
      --replace-fail 'this.canUpdate =' 'this.canUpdate = false; let _dummy ='
  '';

  nodejs = nodejs_20;

  makeCacheWritable = true;
  npmFlags = [
    "--engine-strict"
    "--legacy-peer-deps"
  ];

  npmRebuildFlags = [
    # FIXME one of the esbuild versions fails to download @esbuild/linux-x64
    "--ignore-scripts"
  ];
  npmWorkspace = "apps/desktop";
  npmDepsHash = "sha256-52cLVrfbeNeRH7OKN5QZdGD5VkUVliN0Rn/cbdohsG0=";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      patches
      ;
    hash = "sha256-mt7zWKgH21khAIrfpBFzb+aS2V2mV56zMqCSLzDhGfQ=";
  };
  cargoRoot = "apps/desktop/desktop_native";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # make electron-builder not attempt to codesign the app on darwin
  env.CSC_IDENTITY_AUTO_DISCOVERY = "false";

  nativeBuildInputs =
    [
      cargo
      jq
      makeWrapper
      napi-rs-cli
      pkg-config
      rustc
      rustPlatform.cargoCheckHook
      rustPlatform.cargoSetupHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      copyDesktopItems
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      xcbuild
      darwin.autoSignDarwinBinariesHook
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_14
  ];

  preBuild = ''
    if [[ $(jq --raw-output '.devDependencies.electron' < package.json | grep -E --only-matching '^[0-9]+') != ${lib.escapeShellArg (lib.versions.major electron.version)} ]]; then
      echo 'ERROR: electron version mismatch'
      exit 1
    fi

    pushd apps/desktop/desktop_native/napi
    npm run build
    popd
  '';

  postBuild = ''
    pushd apps/desktop

    # electron-dist needs to be writable on darwin or when using fuses
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version}

    popd
  '';

  # there seem to be issues with missing libs on darwin when running tests
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [
    (gnome-keyring.override { useWrappedDaemon = false; })
  ];

  checkFlags =
    [
      "--skip=password::password::tests::test"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "--skip=clipboard::tests::test_write_read"
    ];

  preCheck = ''
    pushd ${cargoRoot}
    cargoCheckType=release
    HOME=$(mktemp -d)
  '';

  postCheck = ''
    popd
  '';

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -r apps/desktop/dist/mac*/Bitwarden.app $out/Applications
      makeWrapper $out/Applications/Bitwarden.app/Contents/MacOS/Bitwarden $out/bin/bitwarden
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/opt/Bitwarden
      cp -r apps/desktop/dist/linux-*unpacked/{locales,resources{,.pak}} $out/opt/Bitwarden

      makeWrapper '${lib.getExe electron}' "$out/bin/bitwarden" \
        --add-flags $out/opt/Bitwarden/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --set-default ELECTRON_IS_DEV 0 \
        --inherit-argv0

      # Extract the polkit policy file from the multiline string in the source code.
      # This may break in the future but its better than copy-pasting it manually.
      mkdir -p $out/share/polkit-1/actions/
      pushd apps/desktop/src/key-management/biometrics
      awk '/const polkitPolicy = `/{gsub(/^.*`/, ""); print; str=1; next} str{if (/`;/) str=0; gsub(/`;/, ""); print}' os-biometrics-linux.service.ts > $out/share/polkit-1/actions/com.bitwarden.Bitwarden.policy
      popd

      pushd apps/desktop/resources/icons
      for icon in *.png; do
        dir=$out/share/icons/hicolor/"''${icon%.png}"/apps
        mkdir -p "$dir"
        cp "$icon" "$dir"/${icon}.png
      done
      popd
    ''
    + ''
      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "bitwarden";
      exec = "bitwarden %U";
      inherit icon;
      comment = description;
      desktopName = "Bitwarden";
      categories = [ "Utility" ];
      mimeTypes = [ "x-scheme-handler/bitwarden" ];
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version=stable"
        "--version-regex=^desktop-v(.*)$"
      ];
    };
  };

  meta = {
    changelog = "https://github.com/bitwarden/clients/releases/tag/${src.rev}";
    inherit description;
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ amarshall ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "bitwarden";
  };
}
