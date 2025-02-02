{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  wrapGAppsHook3,
  cargo,
  rustc,
  cargo-tauri_1,
  pkg-config,
  esbuild,
  buildGoModule,
  libayatana-appindicator,
  gtk3,
  webkitgtk_4_0,
  libsoup_2_4,
  openssl,
  xdotool,
}:

let
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pot";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "pot-app";
    repo = "pot-desktop";
    rev = finalAttrs.version;
    hash = "sha256-PUXZT1kiInM/CXUoRko/5qlrRurGpQ4ym5YMTgFwuxE=";
  };

  sourceRoot = "${finalAttrs.src.name}/src-tauri";

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-iYQNGRWqXYBU+WIH/Xm8qndgOQ6RKYCtAyi93kb7xrQ=";
  };

  pnpmRoot = "..";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      # All other crates in the same workspace reuse this hash.
      "tauri-plugin-autostart-0.0.0" = "sha256-rWk9Qz1XmByqPRIgR+f12743uYvnEGTHno9RrxmT8JE=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri_1.hook
    nodejs
    pnpm.configHook
    wrapGAppsHook3
    pkg-config
  ];

  buildInputs = [
    gtk3
    libsoup_2_4
    libayatana-appindicator
    openssl
    webkitgtk_4_0
    xdotool
  ];

  env.ESBUILD_BINARY_PATH = "${lib.getExe (
    esbuild.override {
      buildGoModule =
        args:
        buildGoModule (
          args
          // rec {
            version = "0.21.5";
            src = fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              rev = "v${version}";
              hash = "sha256-FpvXWIlt67G8w3pBKZo/mcp57LunxDmRUaCU/Ne89B8=";
            };
          }
        );
    }
  )}";

  preConfigure = ''
    # pnpm.configHook has to write to .., as our sourceRoot is set to src-tauri
    # TODO: move frontend into its own drv
    chmod +w ..
  '';

  meta = {
    description = "Cross-platform translation software";
    mainProgram = "pot";
    homepage = "https://pot-app.com";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ linsui ];
  };
})
