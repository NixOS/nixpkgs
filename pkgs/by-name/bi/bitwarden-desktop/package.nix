{ lib
, buildNpmPackage
, cargo
, copyDesktopItems
, electron_32
, fetchFromGitHub
, glib
, gnome-keyring
, gtk3
, jq
, libsecret
, makeDesktopItem
, makeWrapper
, napi-rs-cli
, nix-update-script
, nodejs_20
, patchutils_0_4_2
, pkg-config
, python3
, runCommand
, rustc
, rustPlatform
, stdenv
}:

let
  description = "Secure and free password manager for all of your devices";
  icon = "bitwarden";
  electron = electron_32;

  bitwardenDesktopNativeArch = {
    aarch64 = "arm64";
    x86_64  = "x64";
  }.${stdenv.hostPlatform.parsed.cpu.name} or (throw "bitwarden-desktop: unsupported CPU family ${stdenv.hostPlatform.parsed.cpu.name}");

in buildNpmPackage rec {
  pname = "bitwarden-desktop";
  version = "2024.11.1";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "desktop-v${version}";
    hash = "sha256-4QTQgW8k3EMf07Xqs2B+VXQOUPzoOgaNvoC02x4zvu8=";
  };

  patches = [
    ./electron-builder-package-lock.patch
    ./dont-auto-setup-biometrics.patch
    ./set-exe-path.patch # ensures `app.getPath("exe")` returns our wrapper, not ${electron}/bin/electron
    ./skip-afterpack.diff # this modifies bin/electron etc., but we wrap read-only bin/electron ourselves
  ];

  postPatch = ''
    # remove code under unfree license
    rm -r bitwarden_license

    substituteInPlace apps/desktop/src/main.ts --replace-fail '%%exePath%%' "$out/bin/bitwarden"
  '';

  nodejs = nodejs_20;

  makeCacheWritable = true;
  npmFlags = [ "--engine-strict" "--legacy-peer-deps" ];
  npmWorkspace = "apps/desktop";
  npmDepsHash = "sha256-YzhCyNMvfXGmgOpl3qWj1Pqd1hY8CJ9QLwQds5ZMnqg=";

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}";
    inherit src;
    patches = map
      (patch: runCommand
        (builtins.baseNameOf patch)
        { nativeBuildInputs = [ patchutils_0_4_2 ]; }
        ''
          < ${patch} filterdiff -p1 --include=${lib.escapeShellArg cargoRoot}'/*' > $out
        ''
      )
      patches;
    patchFlags = [ "-p4" ];
    sourceRoot = "${src.name}/${cargoRoot}";
    hash = "sha256-aurjpVzWET30O+ysyE4ZzauMe8kHjOL169tfKUR1Vpg=";
  };
  cargoRoot = "apps/desktop/desktop_native";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    cargo
    copyDesktopItems
    jq
    makeWrapper
    napi-rs-cli
    pkg-config
    (python3.withPackages (ps: with ps; [ setuptools ]))
    rustc
    rustPlatform.cargoCheckHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    glib
    gtk3
    libsecret
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

    # desktop_native/index.js loads a file of that name regardless of the libc being used
    mv desktop_native/napi/desktop_napi.* desktop_native/napi/desktop_napi.linux-${bitwardenDesktopNativeArch}-musl.node

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    popd
  '';

  doCheck = true;

  nativeCheckInputs = [
    (gnome-keyring.override { useWrappedDaemon = false; })
  ];

  checkFlags = [
    "--skip=password::password::tests::test"
  ];

  preCheck = ''
    pushd ${cargoRoot}
    cargoCheckType=release
    HOME=$(mktemp -d)
  '';

  postCheck = ''
    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out

    pushd apps/desktop/dist/linux-${lib.optionalString stdenv.hostPlatform.isAarch64 "arm64-"}unpacked
    mkdir -p $out/opt/Bitwarden
    cp -r locales resources{,.pak} $out/opt/Bitwarden
    popd

    makeWrapper '${lib.getExe electron}' "$out/bin/bitwarden" \
      --add-flags $out/opt/Bitwarden/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    # Extract the polkit policy file from the multiline string in the source code.
    # This may break in the future but its better than copy-pasting it manually.
    mkdir -p $out/share/polkit-1/actions/
    pushd apps/desktop/src/key-management/biometrics
    awk '/const polkitPolicy = `/{gsub(/^.*`/, ""); print; str=1; next} str{if (/`;/) str=0; gsub(/`;/, ""); print}' biometric.unix.main.ts > $out/share/polkit-1/actions/com.bitwarden.Bitwarden.policy
    popd

    pushd apps/desktop/resources/icons
    for icon in *.png; do
      dir=$out/share/icons/hicolor/"''${icon%.png}"/apps
      mkdir -p "$dir"
      cp "$icon" "$dir"/${icon}.png
    done
    popd

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
      extraArgs = [ "--commit" "--version=stable" "--version-regex=^desktop-v(.*)$" ];
    };
  };

  meta = {
    changelog = "https://github.com/bitwarden/clients/releases/tag/${src.rev}";
    inherit description;
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ amarshall ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "bitwarden";
  };
}
