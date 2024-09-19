{ lib
, buildNpmPackage
, cargo
, copyDesktopItems
, dbus
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
}:

let
  description = "Secure and free password manager for all of your devices";
  icon = "bitwarden";
  electron = electron_32;
in buildNpmPackage rec {
  pname = "bitwarden-desktop";
  version = "2024.9.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "desktop-v${version}";
    hash = "sha256-o5nRG2j73qheDOyeFfSga64D8HbTn1EUrCiN0W+Xn0w=";
  };

  patches = [
    ./electron-builder-package-lock.patch
  ];

  postPatch = ''
    # remove code under unfree license
    rm -r bitwarden_license
  '';

  nodejs = nodejs_20;

  makeCacheWritable = true;
  npmFlags = [ "--engine-strict" "--legacy-peer-deps" ];
  npmWorkspace = "apps/desktop";
  npmDepsHash = "sha256-L7/frKCNlq0xr6T+aSqyEQ44yrIXwcpdU/djrhCJNNk=";

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
    hash = "sha256-y+6vaESiOeVrFJpZoOJ75onOpldqSsT2kqkMMzTDUmM=";
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

  # node-argon2 builds with LTO, but that causes missing symbols. So disable it
  # and rebuild. Then we need to copy it into the build output for
  # electron-builder, as `apps/desktop/src/package.json` specifies `argon2` as
  # a dependency and electron-builder will otherwise install a fresh (and
  # broken) argon2. See https://github.com/ranisalt/node-argon2/pull/415
  preConfigure = ''
    pushd node_modules/argon2
    substituteInPlace binding.gyp --replace-fail '"-flto", ' ""
    "$npm_config_node_gyp" rebuild
    popd
    mkdir -p apps/desktop/build/node_modules
    cp -r ./{,apps/desktop/build/}node_modules/argon2
  '';

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

    # desktop_native/index.js loads a file of that name regarldess of the libc being used
    mv desktop_native/napi/desktop_napi.* desktop_native/napi/desktop_napi.linux-x64-musl.node

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    popd
  '';

  doCheck = true;

  nativeCheckInputs = [
    dbus
    (gnome-keyring.override { useWrappedDaemon = false; })
  ];

  checkFlags = [
    "--skip=password::password::tests::test"
  ];

  checkPhase = ''
    runHook preCheck

    pushd ${cargoRoot}
    export HOME=$(mktemp -d)
    export -f cargoCheckHook runHook _eval _callImplicitHook _logHook
    export cargoCheckType=release
    dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      -- bash -e -c cargoCheckHook
    popd

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out

    pushd apps/desktop/dist/linux-unpacked
    mkdir -p $out/opt/Bitwarden
    cp -r locales resources{,.pak} $out/opt/Bitwarden
    popd

    makeWrapper '${lib.getExe electron}' "$out/bin/bitwarden" \
      --add-flags $out/opt/Bitwarden/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

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
    platforms = [ "x86_64-linux" ];
    mainProgram = "bitwarden";
  };
}
