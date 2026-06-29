{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  perl,
  glib,
  gtk3,
  libsoup_3,
  webkitgtk_4_1,
  libayatana-appindicator,
  cargo-tauri,
  pnpm_9,
  nodejs,
  jq,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    cargoHash = finalAttrs.cargoDeps.hash or "sha256-/ZGUqCYwuyoS2h0Rt8J4IdvtU7vfXbO461Lg1KBWY0o=";
    # -Z flags requires nightly version of rust
    patchCargoToml = ''
      substituteInPlace Cargo.toml \
        --replace-fail ', "-Zthreads=4"' "" \
        --replace-fail 'trim-paths = "all"' "" \
        --replace-fail ', "trim-paths"' ""
    '';
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
      patchPhase = patchCargoToml;
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
    version = "0.26.7";

    src = fetchFromGitHub {
      owner = "hcavarsan";
      repo = "kftray";
      tag = "v${finalAttrs.version}";
      hash = "sha256-QYFNm5eG4koC9BKkq+Cx8XS8ik6bF4ckBrG6BdWvkOs=";
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

    pnpmDeps = pnpm_9.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 1;
      hash = "sha256-fnv59YLPavC2HvNT2tEftcPKhrWKMIIk+KMCDL4jkmo=";
    };

    buildInputs = [
      openssl
      glib
      gtk3
      nodejs
      libsoup_3
      webkitgtk_4_1
      libayatana-appindicator
    ];

    nativeBuildInputs = [
      rustPlatform.cargoSetupHook
      cargo-tauri.hook
      pnpm_9.configHook
      pkg-config
      perl
      jq
    ];

    patchPhase = ''
      ${patchCargoToml}

      # The build script tries to do a copy of kftray-helper, so the following
      # makes sure kftray-helper binary exists in expected location.
      mkdir -p target/release
      ln -s ${kftrayBinaries}/bin/kftray-helper target/release

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

      substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
        --replace-fail \
        "libayatana-appindicator3.so.1" \
        "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    '';

    postInstall = ''
      ln -s ${kftrayBinaries}/bin/kftui $out/bin
    '';

    doCheck = false;

    meta = {
      description = "Kubectl port-forward manager";
      homepage = "https://github.com/hcavarsan/kftray";
      license = with lib.licenses; [ gpl3 ];
      maintainers = [
        # lunkentuss
      ];
      mainProgram = "kftray";
    };
  }
)
