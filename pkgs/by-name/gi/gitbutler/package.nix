{
  lib,
  rustPlatform,
  buildGoModule,
  stdenv,
  fetchFromGitHub,
  pnpm_9,
  wrapGAppsHook3,
  cargo-tauri,
  darwin,
  desktop-file-utils,
  esbuild,
  git,
  glib-networking,
  jq,
  nodejs,
  pkg-config,
  libsoup,
  moreutils,
  openssl,
  webkitgtk,
  nix-update-script,
  cacert,
}:
rustPlatform.buildRustPackage rec {
  pname = "gitbutler";
  version = "0.12.16";

  src = fetchFromGitHub {
    owner = "gitbutlerapp";
    repo = "gitbutler";
    rev = "release/${version}";
    hash = "sha256-L4PVaNb3blpLIcyA7XLc71qwUPUADclxvbOkq1Jc1no=";
  };

  # deactivate the upstream updater in tauri configuration
  # TODO: use `tauri build`'s `--config` flag with the release configuration instead of manually merging
  # them. it doesn't seem to like using paths currently, even though it should.
  postPatch = ''
    jq --slurp ".[0] * .[1] | .tauri.updater.active = false" crates/gitbutler-tauri/tauri.conf{,.release}.json | sponge crates/gitbutler-tauri/tauri.conf.json
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-context-menu-0.7.1" = "sha256-vKfq20hrFLmfoXO94D8HwAE3UdGcuqVZf3+tOBhLqj0=";
      "tauri-plugin-log-0.0.0" = "sha256-gde2RS5NFA0Xap/Xb7XOeVQ/5t2Nw+j+HOwfeJmSNMU=";
    };
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-r2PkNDvOofginL5Y0K+7Qhnsev2zle1q9qraG/ub7Wo=";
  };

  nativeBuildInputs = [
    cargo-tauri
    desktop-file-utils
    jq
    moreutils
    nodejs
    pkg-config
    pnpm_9.configHook
    wrapGAppsHook3
    cacert
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isLinux [
      glib-networking
      libsoup
      webkitgtk
    ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        AppKit
        CoreServices
        Security
        WebKit
      ]
    );

  env = {
    # `pnpm`'s `fetchDeps` and `configHook` uses a specific version of pnpm, not upstream's
    COREPACK_ENABLE_STRICT = 0;

    # disable turbo telemetry
    TURBO_TELEMETRY_DEBUG = 1;

    # we depend on nightly features
    RUSTC_BOOTSTRAP = 1;

    # we also need to have `tracing` support in `tokio` for `console-subscriber`
    RUSTFLAGS = "--cfg tokio_unstable";

    tauriBundle =
      {
        Linux = "deb";
        Darwin = "app";
      }
      .${stdenv.hostPlatform.uname.system}
        or (throw "No tauri bundle available for ${stdenv.hostPlatform.uname.system}");

    ESBUILD_BINARY_PATH = lib.getExe (
      esbuild.override {
        buildGoModule =
          args:
          buildGoModule (
            args
            // rec {
              version = "0.20.2";
              src = fetchFromGitHub {
                owner = "evanw";
                repo = "esbuild";
                rev = "v${version}";
                hash = "sha256-h/Vqwax4B4nehRP9TaYbdixAZdb1hx373dNxNHvDrtY=";
              };

              vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
            }
          );
      }
    );

    # Needed to get openssl-sys to use pkgconfig.
    OPENSSL_NO_VENDOR = true;
  };

  buildPhase = ''
    runHook preBuild

    pushd packages/ui
    pnpm package
    popd

    cargo tauri build --bundles "$tauriBundle"

    runHook postBuild
  '';

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenv.isDarwin ''
      mkdir -p $out/bin
      cp -r target/release/bundle/macos $out/Applications
      mv $out/Applications/GitButler.app/Contents/MacOS/GitButler $out/bin/git-butler
      ln -s $out/bin/git-butler $out/Applications/GitButler.app/Contents/MacOS/GitButler
    ''
    + lib.optionalString stdenv.isLinux ''
      cp -r target/release/bundle/"$tauriBundle"/*/data/usr $out

      desktop-file-edit \
        --set-comment "A Git client for simultaneous branches on top of your existing workflow." \
        --set-key="Keywords" --set-value="git;" \
        --set-key="StartupWMClass" --set-value="GitButler" \
        $out/share/applications/git-butler.desktop
    ''
    + ''
      runHook postInstall
    '';

  # the `gitbutler-git` crate's checks do not support release mode
  checkType = "debug";

  nativeCheckInputs = [ git ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "release/(.*)"
      ];
    };
  };

  meta = {
    description = "Git client for simultaneous branches on top of your existing workflow";
    homepage = "https://gitbutler.com";
    changelog = "https://github.com/gitbutlerapp/gitbutler/releases/tag/release/${version}";
    mainProgram = "git-butler";
    license = lib.licenses.fsl11Mit;
    maintainers = with lib.maintainers; [
      getchoo
      techknowlogick
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
