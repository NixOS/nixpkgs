{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  rustPlatform,
  cacert,
  cargo-tauri,
  darwin,
  desktop-file-utils,
  esbuild,
  git,
  glib-networking,
  jq,
  libsoup,
  moreutils,
  nodejs,
  nix-update-script,
  openssl,
  pkg-config,
  pnpm_9,
  turbo,
  webkitgtk,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitbutler";
  version = "0.12.12";

  src = fetchFromGitHub {
    owner = "gitbutlerapp";
    repo = "gitbutler";
    rev = "release/${version}";
    hash = "sha256-Ogi4AeS6bDW3qFj2jkmhHlf40C6mJEU5lOa0OqG2jSI=";
  };

  patches = [
    # https://discourse.nixos.org/t/rust-with-git-deps-symbolic-link-error-to-cargo-vendor-dep/28841
    ./dedup_gix-path.patch
  ];

  # deactivate the upstream updater in tauri configuration
  # TODO: use `tauri build`'s `--config` flag with the release configuration instead of manually merging
  # them. it doesn't seem to like using paths currently, even though it should.
  postPatch = ''
    jq --slurp ".[0] * .[1] | .tauri.updater.active = false" crates/gitbutler-tauri/tauri.conf{,.release}.json | sponge crates/gitbutler-tauri/tauri.conf.json

    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "gix-0.63.0" = "sha256-I4QPzvwOs/xJHMUQhkZZLLlhcEaCSRvfixe35jl4bRI=";
      "tauri-plugin-context-menu-0.7.1" = "sha256-vKfq20hrFLmfoXO94D8HwAE3UdGcuqVZf3+tOBhLqj0=";
      "tauri-plugin-log-0.0.0" = "sha256-iyJL4B6hvaEu7O7NmB/Bujd3kqB1gcNXH/yWD62b6EE=";
    };
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-OaBPdQyTk/AWF1Cy1M4HRq2D4LxFZIOpu8xZO4pWH5Y=";
  };

  nativeBuildInputs = [
    cacert # turbo wants TLS certs, but doesn't use them?
    cargo-tauri
    desktop-file-utils
    jq
    moreutils
    nodejs
    pkg-config
    pnpm_9.configHook
    wrapGAppsHook3
  ] ++ openssl.nativeBuildInputs; # for openssl-sys

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

    TURBO_BINARY_PATH = lib.getExe turbo;
  };

  buildPhase = ''
    runHook preBuild

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
    license = lib.licenses.fsl11Mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "git-butler";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
