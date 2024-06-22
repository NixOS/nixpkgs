{ lib
, buildNpmPackage
, cargo
, copyDesktopItems
, dbus
, electron_29
, fetchFromGitHub
, glib
, gnome
, gtk3
, jq
, libsecret
, makeDesktopItem
, makeWrapper
, moreutils
, napi-rs-cli
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
  electron = electron_29;
in buildNpmPackage rec {
  pname = "bitwarden-desktop";
  version = "2024.6.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "desktop-v${version}";
    hash = "sha256-qiUUrs23WHE3+KFsWDknuDSA6M3Zwjz9Jdjq6mn5XkE=";
  };

  patches = [
    ./electron-builder-package-lock.patch
  ];

  # The nested package-lock.json from upstream is out-of-date, so copy the
  # lock metadata from the root package-lock.json.
  postPatch = ''
    cat {,apps/desktop/src/}package-lock.json \
      | ${lib.getExe jq} -s '
        .[1].packages."".dependencies.argon2 = .[0].packages."".dependencies.argon2
          | .[0].packages."" = .[1].packages.""
          | .[1].packages = .[0].packages
          | .[1]
        ' \
      | ${moreutils}/bin/sponge apps/desktop/src/package-lock.json
  '';

  nodejs = nodejs_20;

  makeCacheWritable = true;
  npmFlags = [ "--engine-strict" "--legacy-peer-deps" ];
  npmWorkspace = "apps/desktop";
  npmDepsHash = "sha256-Mgd15eFJtWoBqFFCsjmsnlNbcg5NDs1U7DlMkE0hIb8=";

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
    hash = "sha256-BL+j2hMwb3QGgS29Y6LjqnKscH+tEXMCOyivilHHwVI=";
  };
  cargoRoot = "apps/desktop/desktop_native";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    cargo
    copyDesktopItems
    jq
    makeWrapper
    moreutils
    napi-rs-cli
    pkg-config
    python3
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
  '';

  postBuild = ''
    pushd apps/desktop

    # desktop_native/index.js loads a file of that name regarldess of the libc being used
    mv desktop_native/desktop_native.* desktop_native/desktop_native.linux-x64-musl.node

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version}

    popd
  '';

  doCheck = true;

  nativeCheckInputs = [
    dbus
    (gnome.gnome-keyring.override { useWrappedDaemon = false; })
  ];

  checkFlags = [
    "--skip=password::password::tests::test"
  ];

  checkPhase = ''
    runHook preCheck

    pushd ${cargoRoot}
    export HOME=$(mktemp -d)
    export -f cargoCheckHook runHook _eval _callImplicitHook
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
