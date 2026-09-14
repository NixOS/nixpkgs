{
  cargo-nextest,
  cargo-tauri,
  fetchFromGitHub,
  fetchPnpmDeps,
  glib,
  gtk3,
  jq,
  lib,
  libayatana-appindicator,
  libsoup_3,
  nodejs,
  openssl,
  perl,
  pkg-config,
  pnpmConfigHook,
  pnpm_10,
  rustPlatform,
  stdenv,
  webkitgtk_4_1,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (
  finalAttrs:
  let
    cargoHash = finalAttrs.cargoDeps.hash or "sha256-08k5hhMV2YRKNz/Zp+b0WhUVHYRlX7Rhb3xFQefOTw0=";
    kftrayBinaries = rustPlatform.buildRustPackage {
      pname = "kftray-binaries";
      cargoBuildFlags = [
        "-p"
        "kftray-helper"
        "-p"
        "kftui"
      ];
      inherit (finalAttrs) src version;
      cargoHash = cargoHash;
      buildInputs = [
        openssl
        glib
        gtk3
        libayatana-appindicator
        webkitgtk_4_1
      ];

      nativeBuildInputs = [
        pkg-config
        perl
      ];

      doCheck = false;
    };
  in
  {
    pname = "kftray";
    version = "0.27.30";

    src = fetchFromGitHub {
      owner = "hcavarsan";
      repo = "kftray";
      tag = "v${finalAttrs.version}";
      hash = "sha256-PELLoATb8T2jXhiUItVhX+cOd1JCXFRgLUagRa8LOFo=";
    };

    cargoRoot = "./";
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs)
        pname
        version
        src
        cargoRoot
        ;
      hash = cargoHash;
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 4;
      hash = "sha256-LdhXmxdorRsMrX+hMtAbt9NiBW1opO2424bpj+J/c8E=";
    };

    buildInputs = [
      openssl
      glib
      gtk3
      libsoup_3
      webkitgtk_4_1
      libayatana-appindicator
    ];

    nativeBuildInputs = [
      rustPlatform.cargoSetupHook
      cargo-tauri.hook
      pnpmConfigHook
      pnpm
      pkg-config
      perl
      jq
      nodejs
    ];

    postPatch = ''
      # kftray is using the updater plugin. We override the key pair since we
      # want to update with nix. The following is an random generated key pair
      # that holds no significance. Should we able to be simplified once
      # --no-sign flag is available, see
      # https://github.com/tauri-apps/tauri/pull/14052
      export TAURI_SIGNING_PRIVATE_KEY="dW50cnVzdGVkIGNvbW1lbnQ6IHJzaWduIGVuY3J5cHRlZCBzZWNyZXQga2V5ClJXUlRZMEl5SkpzS2h6elk5ZTZZVmhMaE4zL2ExWG1kcWlhYmZ0Y0wwRXhyVnNzNUpYb0FBQkFBQUFBQUFBQUFBQUlBQUFBQW50eHlFN1N1bE8yWFk5ZC9rZ1o1elhUclhpay9aS09jN0JBdkE3V3BaeCtoZDhNKy8zSk9WMWtJd2pJamExWmdZcWh2YUZXMUJVamVNUVo5Y3M4OVBlN05LbURuVUNzTHJzUWN3cWhuZnlKbzcyM21iTy8wQ1Y2elgvT1FXYk5ieE1kUzQ1MDE4YjA9Cg=="
      export TAURI_SIGNING_PRIVATE_KEY_PASSWORD=""
      jq \
        '.plugins.updater.pubkey="dW50cnVzdGVkIGNvbW1lbnQ6IG1pbmlzaWduIHB1YmxpYyBrZXk6IDZCNkZFMkJGOTI2QzgxMkMKUldRc2dXeVN2K0p2YXdYZ3BkVVBxWjIzSk9YaGFIQ3MvN3BMZ2NBR05aU1VCbWdxaVROVmRNVWwK"' \
        < crates/kftray-tauri/tauri.conf.json > tauri.conf.json.tmp
      mv tauri.conf.json.tmp crates/kftray-tauri/tauri.conf.json

      substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
        --replace-fail \
        "libayatana-appindicator3.so.1" \
        "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    '';

    preBuild = ''
      # The build script tries to do a copy of kftray-helper, so the following
      # makes sure kftray-helper binary exists in expected location.
      mkdir -p target/release
      ln -s ${kftrayBinaries}/bin/kftray-helper target/release
    '';

    postInstall = ''
      ln -s ${kftrayBinaries}/bin/kftui $out/bin
    '';

    nativeCheckInputs = [
      cargo-nextest
    ];

    # The below is equivalent to running the mise test:back task. The mise
    # test:server task is skipped since it requires docker.
    checkPhase = ''
      INSTA_UPDATE=always \
      cargo \
        nextest \
        run \
        --profile ci \
        --config-file .cargo/nextest.toml \
        --locked \
        --workspace \
        --all-features \
        --lib \
        --bins \
        --examples \
        --tests \
        -- \
        --skip commands::github::tests::test_import_configs_from_github \
        --skip commands::httplogs::tests::test_is_editor_available
    '';

    doCheck = true;
    strictDeps = true;
    __structuredAttrs = true;

    meta = {
      description = "Kubectl port-forward manager";
      homepage = "https://github.com/hcavarsan/kftray";
      license = with lib.licenses; [ gpl3 ];
      maintainers = with lib.maintainers; [
        lunkentuss
      ];
      mainProgram = "kftray";
    };
  }
)
